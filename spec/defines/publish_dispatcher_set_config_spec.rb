# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::publish_dispatcher_set_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 16 scenario parameters' do
        let(:title) { 'Set publish-dispatcher config' }
        let(:params) do
          {
            dispatcher_conf_dir: '/tmp/shinesolutions/puppet-aem-resources/publish-dispatcher/',
            virtual_hosts_dir: '/tmp/shinesolutions/puppet-aem-resources/publish-virtual-hosts/',
            docroot_dir: '/path/to/some/docroot/',
            allowed_client: '*.*.*.*',
            publish_host: 'somepublishhost',
            publish_port: 4503,
            publish_secure: 1,
            ssl_cert: '/etc/ssl/aem.unified-dispatcher.cert',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/tmp/shinesolutions/puppet-aem-resources/publish-dispatcher//dispatcher.farms.any') }
        it { is_expected.to contain_file('/tmp/shinesolutions/puppet-aem-resources/publish-virtual-hosts//1-puppet-aem-resources.conf') }
      end
    end
  end
end
