# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::remove_authorizable_keystore_certificate' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 66 scenario parameters' do
        let(:title) { 'Remove certificate chain to authorizable keystore' }
        let(:params) { { authorizable_id: 'authentication-service', intermediate_path: '/home/users/system', private_key_alias: 'somealias' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_certificate_chain('[aem] Remove certificate chain from authorizable keystore for user authentication-service') }
      end
    end
  end
end
