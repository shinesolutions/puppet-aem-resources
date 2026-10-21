# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::create_system_users' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 20 scenario parameters' do
        let(:title) { 'Create system users with default usernames, paths, and passwords' }

        it { is_expected.to compile.with_all_deps }
      end

      context 'with the 21 scenario parameters' do
        let(:title) { 'Create system users with predefined password' }
        let(:params) do
          {
            aem_system_users: {
              'deployer' => { 'name' => 'deployer', 'path' => '/home/users/q', 'password' => 'customdeployerpassword' },
              'exporter' => { 'name' => 'exporter', 'path' => '/home/users/e', 'password' => 'customexporterpassword' },
              'importer' => { 'name' => 'importer', 'path' => '/home/users/i', 'password' => 'customimporterpassword' },
              'orchestrator' => { 'name' => 'orchestrator', 'path' => '/home/users/o', 'password' => 'customorchestratorpassword' },
              'replicator' => { 'name' => 'replicator', 'path' => '/home/users/r', 'password' => 'customreplicatorpassword' },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
