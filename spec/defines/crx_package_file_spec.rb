# frozen_string_literal: true

require 'spec_helper'

# Parameters are those aem_resources::instance_config passes for a CRX package, with the
# somepackage-1.2.3.zip acceptance fixture as the source (no scenario passes crx_packages)
describe 'aem_resources::crx_package_file' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the somepackage-1.2.3.zip acceptance fixture' do
        let(:title) { '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/install/somepackage-1.2.3.zip' }
        let(:params) do
          {
            ensure: 'present',
            group: 'aem',
            home: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2',
            source: '/tmp/shinesolutions/puppet-aem-resources/somepackage-1.2.3.zip',
            user: 'aem',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/install/somepackage-1.2.3.zip').with(
            ensure: 'present',
            owner: 'aem',
            group: 'aem',
            mode: '0664',
            source: '/tmp/shinesolutions/puppet-aem-resources/somepackage-1.2.3.zip',
          )
        end
      end
    end
  end
end
