# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::add_authorizable_keystore_certificate' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 63 scenario parameters' do
        let(:title) { 'Add certificate chain to authorizable keystore' }
        let(:params) do
          {
            authorizable_id: 'authentication-service',
            intermediate_path: '/home/users/system',
            certificate_chain_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_chain.crt',
            private_key_file_path: '/tmp/shinesolutions/puppet-aem-resources/private_key.der',
            private_key_alias: 'somealias',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_certificate_chain('aem_certificate_chain').with_certificate_chain_file_path('/tmp/shinesolutions/puppet-aem-resources/cert_chain.crt') }
      end
    end
  end
end
