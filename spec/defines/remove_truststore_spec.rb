# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::remove_truststore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 69 scenario parameters' do
        let(:title) { 'Remove AEM Truststore' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_truststore('[aem] Remove truststore') }
      end
    end
  end
end
