# frozen_string_literal: true

require 'spec_helper'

# Titles and parameters are those of the spec/acceptance/manifests scenarios
describe 'aem_resources::deploy_packages' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with the 30 scenario parameters' do
        let(:title) { 'Deploy packages' }
        let(:params) do
          {
            packages: [
              {
                'ensure' => 'present',
                'name' => 'somepackage',
                'version' => '1.2.3',
                'group' => 'somepackagegroup',
                'replicate' => true,
                'activate' => true,
                'force' => true,
              },
            ],
            aem_id: 'author',
            path: '/tmp/shinesolutions/puppet-aem-resources/',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aem_package('[author] Deploy package somepackagegroup/somepackage-1.2.3') }
      end
    end
  end
end
