# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::publish_set_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 12 scenario parameters' do
        let(:title) { 'Set Publish config' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/publish' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Publish') }
      end

      context 'with the 12a scenario parameters' do
        let(:title) { 'Set Publish config' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/publish', aem_runmodes: ['dynamicmedia_scene7'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Publish') }
      end

      context 'with the 12b scenario parameters' do
        let(:title) { 'Set Publish config' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/publish', aem_runmodes: ['dynamicmedia_scene7'], jvm_opts: '-Dkey=value' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Publish') }
      end
    end
  end
end
