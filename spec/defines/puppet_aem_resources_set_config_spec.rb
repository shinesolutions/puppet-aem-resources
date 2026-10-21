# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::puppet_aem_resources_set_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 50 author 1 scenario parameters' do
        let(:title) { 'Set puppet-aem-resources config file for author 1' }
        let(:params) do
          {
            conf_dir: '/tmp/shinesolutions/puppet-aem-resources/',
            username: 'admin',
            protocol: 'http',
            host: 'localhost',
            port: 4502,
            timeout: 300,
            debug: false,
            aem_id: 'test-aem-author1',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/tmp/shinesolutions/puppet-aem-resources//test-aem-author1.yaml') }
      end

      context 'with the 50 author 2 scenario parameters' do
        let(:title) { 'Set puppet-aem-resources config file for author 2' }
        let(:params) do
          {
            conf_dir: '/tmp/shinesolutions/puppet-aem-resources/',
            username: 'admin',
            protocol: 'http',
            host: 'localhost',
            port: 4502,
            timeout: 300,
            debug: false,
            aem_id: 'test-aem-author2',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/tmp/shinesolutions/puppet-aem-resources//test-aem-author2.yaml') }
      end
    end
  end
end
