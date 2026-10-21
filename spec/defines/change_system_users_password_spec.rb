# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::change_system_users_password' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 21 scenario parameters' do
        let(:title) { 'Update system users password with same value as original' }
        let(:params) do
          {
            aem_system_users: {
              'deployer' => { 'name' => 'deployer', 'path' => '/home/users/q', 'old_password' => 'customdeployerpassword', 'new_password' => 'customdeployerpassword' },
              'exporter' => { 'name' => 'exporter', 'path' => '/home/users/e', 'old_password' => 'customexporterpassword', 'new_password' => 'customexporterpassword' },
              'importer' => { 'name' => 'importer', 'path' => '/home/users/i', 'old_password' => 'customimporterpassword', 'new_password' => 'customimporterpassword' },
              'orchestrator' => { 'name' => 'orchestrator', 'path' => '/home/users/o', 'old_password' => 'customorchestratorpassword', 'new_password' => 'customorchestratorpassword' },
              'replicator' => { 'name' => 'replicator', 'path' => '/home/users/r', 'old_password' => 'customreplicatorpassword', 'new_password' => 'customreplicatorpassword' },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_user_alias('[aem] Change user password - orchestrator') }
      end

      context 'with the 22 scenario parameters' do
        let(:title) { 'Change system users password the second time but with new password' }
        let(:params) do
          {
            aem_system_users: {
              'deployer' => { 'name' => 'deployer', 'path' => '/home/users/q', 'old_password' => 'customdeployerpassword', 'new_password' => 'newdeployerpassword' },
              'exporter' => { 'name' => 'exporter', 'path' => '/home/users/e', 'old_password' => 'customexporterpassword', 'new_password' => 'newexporterpassword' },
              'importer' => { 'name' => 'importer', 'path' => '/home/users/i', 'old_password' => 'customimporterpassword', 'new_password' => 'newimporterpassword' },
              'orchestrator' => { 'name' => 'orchestrator', 'path' => '/home/users/o', 'old_password' => 'customorchestratorpassword', 'new_password' => 'neworchestratorpassword' },
              'replicator' => { 'name' => 'replicator', 'path' => '/home/users/r', 'old_password' => 'customreplicatorpassword', 'new_password' => 'newreplicatorpassword' },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_user_alias('[aem] Change user password - orchestrator') }
      end
    end
  end
end
