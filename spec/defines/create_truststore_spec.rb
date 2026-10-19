# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::create_truststore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 60 scenario parameters' do
        let(:title) { 'Create AEM Truststore' }
        let(:params) { { truststore_password: 'sometruststorepassword' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_truststore('[aem] Create new Truststore') }
      end
    end
  end
end
