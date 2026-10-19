# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::remove_truststore_certificate' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 68 scenario parameters' do
        let(:title) { 'Remove certificate from AEM Truststore' }
        let(:params) { { file: '/tmp/shinesolutions/puppet-aem-resources/saml.crt' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_certificate('aem_certificate').with_ensure('absent') }
      end
    end
  end
end
