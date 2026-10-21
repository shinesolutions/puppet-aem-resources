# frozen_string_literal: true

require 'spec_helper'

# Parameters are those that aem_resources::set_osgi_config passes for the 09 acceptance scenario
describe 'aem_resources::osgi_config_file' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 09 scenario parameters' do
        let(:title) { '[aem]: Set Osgi Config org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService' }
        let(:params) do
          {
            ensure: 'present',
            group: 'aem',
            home: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2',
            pid: 'org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService',
            properties: {
              'org.apache.sling.installer.configuration.persist' => false,
              'name' => 'Oak-Tar',
              'service.ranking' => 100,
              'standby' => false,
              'customBlobstore' => true,
            },
            user: 'aem',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file(
            '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/crx-quickstart/install/org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.config',
          ).with(
            ensure: 'present',
            owner: 'aem',
            group: 'aem',
            mode: '0664',
            content: <<~CONFIG,
              service.pid="org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService"
              org.apache.sling.installer.configuration.persist=B"false"
              name="Oak-Tar"
              service.ranking=L"100"
              standby=B"false"
              customBlobstore=B"true"
            CONFIG
          )
        end
      end

      # Properties author_standby_set_config builds for the 11 aem62 scenario, with an undef primary.host
      context 'with an undef property value' do
        let(:title) { 'org.apache.jackrabbit.oak.plugins.segment.standby.store.StandbyStoreService' }
        let(:params) do
          {
            ensure: 'present',
            group: 'aem',
            home: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2',
            pid: :undef,
            properties: {
              'org.apache.sling.installer.configuration.persist' => false,
              'mode' => 'standby',
              'primary.host' => :undef,
              'port' => 8023,
              'secure' => true,
              'interval' => 5,
            },
            user: 'aem',
          }
        end

        it { is_expected.to compile.and_raise_error(%r{Left match operand must result in a String value\. Got an Undef Value\. \(OSGi property 'primary\.host'\)}) }
      end
    end
  end
end
