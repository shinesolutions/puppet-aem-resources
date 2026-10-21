# frozen_string_literal: true

require 'spec_helper'

# Parameters are those that the *_set_config defines pass for the spec/acceptance/manifests scenarios
describe 'aem_resources::instance_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the parameters author_primary_set_config passes for the 10b aem63 scenario' do
        let(:title) { 'Configure AEM Author-Primary' }
        let(:home) { '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/' }
        let(:params) do
          {
            context_root: :undef,
            debug_port: :undef,
            group: 'aem',
            home: home,
            jvm_mem_opts: '-Xmx1024m',
            jvm_opts: '-Dkey=value',
            osgi_configs: {
              'org.apache.jackrabbit.oak.segment.SegmentNodeStoreService' => {
                'org.apache.sling.installer.configuration.persist' => false,
                'name' => 'Oak-Tar',
                'service.ranking' => 100,
                'standby' => false,
                'customBlobStore' => true,
              },
              'org.apache.jackrabbit.oak.segment.standby.store.StandbyStoreService' => {
                'org.apache.sling.installer.configuration.persist' => false,
                'mode' => 'primary',
                'port' => 8023,
                'secure' => true,
                'interval' => 5,
              },
              'org.apache.jackrabbit.oak.plugins.blob.datastore.FileDataStore' => {
                'org.apache.sling.installer.configuration.persist' => false,
                'path' => './crx-quickstart/repository/datastore',
                'minRecordLength' => 16_384,
              },
            },
            crx_packages: :undef,
            port: '4502',
            runmodes: ['primary', 'dynamicmedia_scene7'],
            sample_content: false,
            type: 'aem',
            user: 'aem',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file("#{home}/crx-quickstart/bin/start-env").with(
            ensure: 'file',
            owner: 'aem',
            group: 'aem',
            mode: '0775',
            content: <<~START_ENV,
              #!/bin/bash
              #
              # ************************************
              # Managed by Puppet AEM Module
              # ************************************
              #
              # This file manages the configuration of the run script.
              #

              TYPE='aem'
              PORT=4502
              RUNMODES='primary,dynamicmedia_scene7'
              SAMPLE_CONTENT='nosamplecontent'
              DEBUG_PORT=



              JVM_MEM_OPTS='-Xmx1024m'

              DEFAULT_JVM_OPTS='-server -Djava.awt.headless=true'
              JVM_OPTS='-Dkey=value'

              SLING_PROPS='conf/sling.properties'

              # Do we ever implement these?
              #HOST=
              #FILE_SIZE_LIMIT

              # This doesn't ever seem to work
              #LOG_LEVEL=
            START_ENV
          )
        end

        it do
          is_expected.to contain_file("#{home}/crx-quickstart/bin/start.orig").with(
            ensure: 'file',
            replace: false,
            source: "#{home}/crx-quickstart/bin/start",
            mode: '0775',
          )
        end

        it do
          is_expected.to contain_file("#{home}/crx-quickstart/bin/start").with(
            ensure: 'file',
            mode: '0775',
            content: %r{\A#!/bin/bash\n.*^\. bin/start-env$.*^sleep 15\n\z}m,
          ).that_requires("File[#{home}/crx-quickstart/bin/start.orig]")
        end

        it { is_expected.to contain_file("#{home}/crx-quickstart/install").with(ensure: 'directory', mode: '0775') }

        [
          'org.apache.jackrabbit.oak.segment.SegmentNodeStoreService',
          'org.apache.jackrabbit.oak.segment.standby.store.StandbyStoreService',
          'org.apache.jackrabbit.oak.plugins.blob.datastore.FileDataStore',
        ].each do |pid|
          it do
            is_expected.to contain_aem_resources__osgi_config_file(pid).with(
              ensure: 'present',
              group: 'aem',
              home: home,
              pid: nil,
              user: 'aem',
            )
          end

          it { is_expected.to contain_file("#{home}/crx-quickstart/install/#{pid}.config").with_content(%r{\Aservice\.pid="#{Regexp.escape(pid)}"\n}) }
        end

        it { is_expected.to have_aem_resources__crx_package_file_resource_count(0) }
      end

      context 'with the parameters publish_set_config passes for the 12 scenario' do
        let(:title) { 'Configure AEM Publish' }
        let(:home) { '/tmp/shinesolutions/puppet-aem-resources/publish' }
        let(:params) do
          {
            context_root: :undef,
            debug_port: :undef,
            group: 'aem',
            home: home,
            jvm_mem_opts: '-Xmx1024m',
            jvm_opts: :undef,
            osgi_configs: {},
            crx_packages: :undef,
            port: '4503',
            runmodes: [],
            sample_content: false,
            type: 'aem',
            user: 'aem',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file("#{home}/crx-quickstart/bin/start-env").with_content(%r{^PORT=4503\nRUNMODES=''\n}) }
        it { is_expected.to contain_file("#{home}/crx-quickstart/bin/start-env").with_content(%r{^JVM_OPTS=''$}) }
        it { is_expected.to contain_file("#{home}/crx-quickstart/install").with(ensure: 'directory') }
        it { is_expected.to have_aem_resources__osgi_config_file_resource_count(0) }
      end
    end
  end
end
