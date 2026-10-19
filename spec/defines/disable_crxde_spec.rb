# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::disable_crxde' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 40 scenario parameters' do
        let(:title) { 'Disable CRXDE' }
        let(:params) { { run_mode: 'author' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_bundle('[aem] Stop davex bundle') }
      end
    end
  end
end
