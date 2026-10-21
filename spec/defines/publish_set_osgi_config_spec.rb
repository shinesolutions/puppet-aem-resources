# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::publish_set_osgi_config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 14 scenario parameters' do
        let(:title) { 'Set publish OSGI config' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_node('[aem] Create Apache Sling Referrer Filter config node') }
      end
    end
  end
end
