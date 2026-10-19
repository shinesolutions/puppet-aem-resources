# frozen_string_literal: true

require 'spec_helper'

# No spec/acceptance/manifests scenario uses this define, so only its defaults are tested
describe 'aem_resources::archive_truststore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with defaults for all parameters' do
        let(:title) { 'Archive AEM Truststore' }

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
