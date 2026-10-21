# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::enable_crxde' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 41 scenario parameters' do
        let(:title) { 'Enable CRXDE' }
        let(:params) { { run_mode: 'author' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_bundle('[aem] Start davex bundle') }
      end
    end
  end
end
