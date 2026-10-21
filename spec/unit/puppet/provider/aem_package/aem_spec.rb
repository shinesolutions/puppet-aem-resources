# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_package provider: the ruby_aem calls it makes and their arguments, including
# the Package Manager readiness checks, with the ruby_aem client stubbed. Values are those of
# spec/acceptance/resources/31, 32, 33 and 34. Whether AEM uploads, installs or builds the package
# needs `make test-integration`.
describe Puppet::Type.type(:aem_package).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:package) { instance_double(RubyAem::Resources::Package) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
  end

  context 'with the 32 scenario (present, replicate, force, retries)' do
    let(:resource) do
      build_resource(:aem_package, 'Install package',
                     ensure: 'present', name: 'somepackage', version: '1.2.3', group: 'somepackagegroup',
                     path: '/tmp/shinesolutions/puppet-aem-resources/', replicate: true, activate: false, force: true,
                     retries_max_tries: 60, retries_base_sleep_seconds: 5, retries_max_sleep_seconds: 5)
    end
    let(:retries) { { _retries: { max_tries: 60, base_sleep_seconds: 5, max_sleep_seconds: 5 } } }

    before(:each) do
      allow(aem).to receive(:package).with('somepackagegroup', 'somepackage', '1.2.3').and_return(package)
    end

    it 'treats the package as not installed without asking AEM' do
      expect(package).not_to receive(:is_installed)
      expect(provider.exists?).to be(false)
    end

    it 'uploads, installs and replicates the package, each after a readiness check with the resource retries' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(retries).exactly(3).times
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(package).to receive(:upload_wait_until_ready).with('/tmp/shinesolutions/puppet-aem-resources/', { force: true, **retries }).ordered
                                                          .and_return(aem_result('Package uploaded'))
      expect(package).to receive(:install_wait_until_ready).with(retries).ordered.and_return(aem_result('Package installed'))
      expect(package).to receive(:replicate).ordered.and_return(aem_result('Package replicated'))
      expect(package).not_to receive(:activate_filter)
      provider.create
    end

    it 'passes the upload option ruby_aem interpolates' do
      allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).and_return(aem_result('ready'))
      allow(package).to receive_messages(install_wait_until_ready: aem_result('installed'), replicate: aem_result('replicated'))
      upload_opts = {}
      allow(package).to receive(:upload_wait_until_ready) do |_file_path, opts|
        upload_opts = opts
        aem_result('uploaded')
      end
      provider.create
      expect(ruby_aem_spec_keys('package', 'upload') - upload_opts.keys).to be_empty
    end
  end

  context 'with the 33 scenario (reinstalled)' do
    let(:resource) do
      build_resource(:aem_package, 'Install package',
                     ensure: 'reinstalled', name: 'somepackage', version: '1.2.3', group: 'somepackagegroup',
                     path: '/tmp/shinesolutions/puppet-aem-resources/', replicate: true, activate: false, force: true,
                     retries_max_tries: 60, retries_base_sleep_seconds: 5, retries_max_sleep_seconds: 5)
    end
    let(:retries) { { _retries: { max_tries: 60, base_sleep_seconds: 5, max_sleep_seconds: 5 } } }

    it 'installs and replicates the package again, without uploading it' do
      allow(aem).to receive(:package).with('somepackagegroup', 'somepackage', '1.2.3').and_return(package)
      allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(retries).and_return(aem_result('Package Manager ready'))
      expect(package).not_to receive(:upload_wait_until_ready)
      expect(package).to receive(:install_wait_until_ready).with(retries).ordered.and_return(aem_result('Package installed'))
      expect(package).to receive(:replicate).ordered.and_return(aem_result('Package replicated'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 31 scenario (archived)' do
    let(:resource) do
      build_resource(:aem_package, 'Archive package',
                     ensure: 'archived', name: 'somearchivedpackage', version: '1.2.3', group: 'somepackagegroup',
                     path: '/tmp/shinesolutions/puppet-aem-resources/',
                     filter: '[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]')
    end

    it 'deletes every existing version, then creates, filters, builds and downloads the package after readiness checks' do
      allow(aem).to receive(:package).with('somepackagegroup', 'somearchivedpackage', '1.2.3').and_return(package)
      allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).and_return(aem_result('Package Manager ready'))
      expect(package).to receive(:get_versions).ordered.and_return(aem_result('Package versions', ['1.2.3']))
      expect(package).to receive(:exists).ordered.and_return(aem_result('Package exists', true))
      expect(package).to receive(:delete_wait_until_ready).ordered.and_return(aem_result('Package deleted'))
      expect(package).to receive(:create).ordered.and_return(aem_result('Package created'))
      expect(package).to receive(:update).with('[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]').ordered
                                         .and_return(aem_result('Package updated'))
      expect(package).to receive(:build_wait_until_ready).with(unset_retries).ordered.and_return(aem_result('Package built'))
      expect(package).to receive(:download).with('/tmp/shinesolutions/puppet-aem-resources/').ordered.and_return(aem_result('Package downloaded'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 34 scenario (absent)' do
    let(:resource) do
      build_resource(:aem_package, 'Delete package', ensure: 'absent', name: 'somepackage', version: '1.2.3', group: 'somepackagegroup')
    end

    before(:each) do
      allow(aem).to receive(:package).with('somepackagegroup', 'somepackage', '1.2.3').and_return(package)
    end

    it 'asks AEM whether the package is installed' do
      allow(package).to receive(:is_installed).and_return(aem_result('Package installed', true))
      expect(provider.exists?).to be(true)
    end

    it 'uninstalls an installed package, then deletes it' do
      expect(package).to receive(:is_installed).ordered.and_return(aem_result('Package installed', true))
      expect(package).to receive(:uninstall).ordered.and_return(aem_result('Package uninstalled'))
      expect(package).to receive(:delete).ordered.and_return(aem_result('Package deleted'))
      provider.destroy
    end

    it 'only deletes a package that is not installed' do
      allow(package).to receive(:is_installed).and_return(aem_result('Package not installed', false))
      expect(package).not_to receive(:uninstall)
      expect(package).to receive(:delete).and_return(aem_result('Package deleted'))
      provider.destroy
    end
  end
end
