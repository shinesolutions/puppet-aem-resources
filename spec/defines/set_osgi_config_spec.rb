# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::set_osgi_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 09 scenario parameters' do
        let(:title) { 'Set OSGI configuration' }
        let(:params) do
          {
            ensure: 'present',
            aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2',
            osgi_configs: {
              'org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService' => {
                'org.apache.sling.installer.configuration.persist' => false,
                'name' => 'Oak-Tar',
                'service.ranking' => 100,
                'standby' => false,
                'customBlobstore' => true,
              },
              'org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService' => {
                'org.apache.sling.installer.configuration.persist' => false,
                'mode' => 'primary',
                'port' => 8023,
                'secure' => true,
                'interval' => 5,
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem__osgi__config('[aem]: Set Osgi Config org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService') }
      end
    end
  end
end
