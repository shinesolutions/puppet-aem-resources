# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::author_standby_set_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 11 aem62 scenario parameters' do
        let(:title) { 'Set author standby config for AEM 6.2 (default)' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2', primary_host: 'somehost' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Standby') }
      end

      context 'with the 11 aem63 scenario parameters' do
        let(:title) { 'Set author standby config for AEM 6.3' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.3', primary_host: 'somehost', aem_version: '6.3' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Standby') }
      end

      context 'with the 11b aem62 scenario parameters' do
        let(:title) { 'Set author standby config for AEM 6.2 (default)' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2', primary_host: 'somehost', aem_runmodes: ['dynamicmedia_scene7'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Standby') }
      end

      context 'with the 11b aem63 scenario parameters' do
        let(:title) { 'Set author standby config for AEM 6.3' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.3', primary_host: 'somehost', aem_version: '6.3', aem_runmodes: ['dynamicmedia_scene7'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Standby') }
      end
    end
  end
end
