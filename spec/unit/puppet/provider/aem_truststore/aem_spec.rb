# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_truststore provider: the ruby_aem calls it makes and their arguments,
# including the Package Manager readiness checks, with the ruby_aem client stubbed. Values are those
# of spec/acceptance/resources/53, 58 and 67 and of aem_resources::create_truststore as the
# spec/acceptance/manifests/60 scenario declares it (force defaults to true there).
# Whether AEM accepts these calls needs a running AEM: see `make test-integration`.
describe Puppet::Type.type(:aem_truststore).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:truststore) { instance_double(RubyAem::Resources::Truststore) }
  let(:provider) { resource.provider }
  # call_with_readiness_check passes the resource's retries_* values, which these scenarios don't set
  let(:readiness_opts) { { _retries: { max_tries: nil, base_sleep_seconds: nil, max_sleep_seconds: nil } } }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive_messages(aem: aem_instance, truststore: truststore)
    allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(readiness_opts)
                                                                                        .and_return(aem_result('Package Manager ready'))
  end

  context 'with the 53 scenario (present, no force)' do
    let(:resource) { build_resource(:aem_truststore, 'Create Truststore', ensure: 'present', password: 'sometruststorepassword') }

    it 'waits for the Package Manager, then asks AEM whether the truststore exists' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(readiness_opts).ordered
      expect(truststore).to receive(:exists).ordered.and_return(aem_result('Truststore exists', true))
      expect(provider.exists?).to be(true)
    end

    it 'creates the truststore with its password, without deleting an existing one first' do
      expect(truststore).not_to receive(:exists)
      expect(truststore).not_to receive(:delete)
      expect(truststore).to receive(:create).with('sometruststorepassword').and_return(aem_result('Truststore created'))
      provider.create
    end
  end

  context 'with the 60 scenario (aem_resources::create_truststore, present, force)' do
    let(:resource) do
      build_resource(:aem_truststore, '[aem] Create new Truststore',
                     ensure: 'present', aem_id: 'aem', password: 'sometruststorepassword', force: true)
    end

    it 'treats the truststore as missing without asking AEM' do
      expect(truststore).not_to receive(:exists)
      expect(provider.exists?).to be(false)
    end

    it 'deletes an existing truststore, then creates it' do
      expect(truststore).to receive(:exists).ordered.and_return(aem_result('Truststore exists', true))
      expect(truststore).to receive(:delete).ordered.and_return(aem_result('Truststore deleted'))
      expect(truststore).to receive(:create).with('sometruststorepassword').ordered.and_return(aem_result('Truststore created'))
      provider.create
    end

    it 'creates the truststore without deleting when none exists' do
      allow(truststore).to receive(:exists).and_return(aem_result('Truststore not found', false))
      expect(truststore).not_to receive(:delete)
      expect(truststore).to receive(:create).with('sometruststorepassword').and_return(aem_result('Truststore created'))
      provider.create
    end
  end

  context 'with the 58 scenario (archived)' do
    let(:resource) { build_resource(:aem_truststore, 'Create Truststore', ensure: 'archived', path: '/tmp/shinesolutions/puppet-aem-resources') }

    it 'downloads the truststore to truststore.p12 in path' do
      expect(truststore).to receive(:download).with('/tmp/shinesolutions/puppet-aem-resources/truststore.p12')
                                              .and_return(aem_result('Truststore downloaded'))
      provider.archive
    end
  end

  context 'with the 67 scenario (absent)' do
    let(:resource) { build_resource(:aem_truststore, 'Delete Truststore', ensure: 'absent') }

    it 'waits for the Package Manager, then deletes the truststore' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(readiness_opts).ordered
      expect(truststore).to receive(:delete).ordered.and_return(aem_result('Truststore deleted'))
      provider.destroy
    end
  end
end
