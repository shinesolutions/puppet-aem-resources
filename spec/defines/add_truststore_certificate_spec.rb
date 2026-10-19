# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::add_truststore_certificate' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 61 scenario parameters' do
        let(:title) { 'Create AEM Truststore' }
        let(:params) { { file: '/tmp/shinesolutions/puppet-aem-resources/saml.crt' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_certificate('aem_certificate').with_file('/tmp/shinesolutions/puppet-aem-resources/saml.crt') }
      end
    end
  end
end
