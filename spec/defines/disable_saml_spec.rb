# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::disable_saml' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 65 scenario parameters' do
        let(:title) { 'Disabling SAML authentication' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_saml('[aem] Disable SAML authentication').with_ensure('absent') }
      end
    end
  end
end
