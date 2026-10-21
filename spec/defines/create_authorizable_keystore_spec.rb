# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::create_authorizable_keystore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 62 scenario parameters' do
        let(:title) { 'Create authorizable Keystore' }
        let(:params) do
          {
            authorizable_id: 'authentication-service',
            intermediate_path: '/home/users/system',
            authorizable_keystore_password: 'somepassword',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_authorizable_keystore('[aem] Create new Keystore for user authentication-service') }
      end
    end
  end
end
