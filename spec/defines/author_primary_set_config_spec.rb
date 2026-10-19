# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::author_primary_set_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 10 aem62 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.2 (default)' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 10 aem63 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.3' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/', aem_version: '6.3' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 10a aem62 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.2 (default)' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/', aem_runmodes: ['dynamicmedia_scene7'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 10a aem63 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.3' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/', aem_version: '6.3', aem_runmodes: ['dynamicmedia_scene7'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 10b aem62 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.2' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.2/', aem_version: '6.2', aem_runmodes: ['dynamicmedia_scene7'], jvm_opts: '-Dkey=value' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 10b aem63 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.3' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-primary-6.3/', aem_version: '6.3', aem_runmodes: ['dynamicmedia_scene7'], jvm_opts: '-Dkey=value' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 11a aem62 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.2' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 11a aem63 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.3' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.3', aem_version: '6.3' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 11c aem62 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.2' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.2', aem_runmodes: ['dynamicmedia_scene7'] } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end

      context 'with the 11c aem63 scenario parameters' do
        let(:title) { 'Set author primary config for AEM 6.3' }
        let(:params) { { aem_home_dir: '/tmp/shinesolutions/puppet-aem-resources/author-standby-6.3', aem_runmodes: ['dynamicmedia_scene7'], aem_version: '6.3' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_resources__instance_config('Configure AEM Author-Primary') }
      end
    end
  end
end
