# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::author_remove_default_agents' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 00 scenario parameters' do
        let(:title) { 'Remove default author agents' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_flush_agent('[aem] Delete author flush agent - flush') }
      end
    end
  end
end
