# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_aem provider's ensure values: which ruby_aem wait it calls and the retry
# options it passes, and the agent removal and package listing, with the ruby_aem client stubbed.
# Values are those of spec/acceptance/resources/00, 01, 01b, 01c, 02 and 03; the agent names are
# those aem_resources::author_remove_default_agents removes. What AEM does needs `make test-integration`.
describe Puppet::Type.type(:aem_aem).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:retries) { { max_tries: 60, base_sleep_seconds: 5, max_sleep_seconds: 5 } }
  let(:retry_params) { { retries_max_tries: 60, retries_base_sleep_seconds: 5, retries_max_sleep_seconds: 5 } }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
  end

  context 'with the 00 scenario (aem_health_check_is_ok)' do
    let(:resource) do
      build_resource(:aem_aem, 'Wait until health is ok',
                     ensure: 'aem_health_check_is_ok', tags: 'shallow', combine_tags_or: false, **retry_params)
    end

    it 'waits until the AEM health check is OK, with the tags and retries' do
      expect(aem_instance).to receive(:get_aem_health_check_wait_until_ok).with({ tags: 'shallow', combine_tags_or: false, _retries: retries })
                                                                          .and_return(aem_result('AEM health check is OK'))
      resource.property(:ensure).sync
    end

    it 'fails the resource when AEM is not healthy after the retries' do
      allow(aem_instance).to receive(:get_aem_health_check_wait_until_ok).and_raise(StandardError, 'AEM health check is not OK')
      expect { resource.property(:ensure).sync }.to raise_error(Puppet::ResourceError, %r{AEM health check is not OK})
    end

    it 'always reports AEM as present, so the wait runs on every Puppet run' do
      expect(resource.provider.exists?).to be(true)
    end
  end

  context 'with the 01 scenario (login_page_is_ready)' do
    let(:resource) { build_resource(:aem_aem, 'Wait until login page is ready', ensure: 'login_page_is_ready', **retry_params) }

    it 'waits until the login page is ready, with the retries' do
      expect(aem_instance).to receive(:get_login_page_wait_until_ready).with({ _retries: retries }).and_return(aem_result('Login page ready'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 01b scenario (install_status_is_finished)' do
    let(:resource) { build_resource(:aem_aem, 'Wait until install status is finished', ensure: 'install_status_is_finished', **retry_params) }

    it 'waits until the install status is finished, with the retries' do
      expect(aem_instance).to receive(:get_install_status_wait_until_finished).with({ _retries: retries }).and_return(aem_result('Install status finished'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 02 scenario (all_agents_removed)' do
    let(:resource) { build_resource(:aem_aem, 'Remove all agents', ensure: 'all_agents_removed', run_mode: 'author') }
    let(:agent_names) { ['publish', 'flush', 'publish_reverse', 'static', 'test_and_target'] }

    it 'deletes every replication agent AEM lists for the run mode, each after a readiness check' do
      allow(aem_instance).to receive(:get_agents).with('author').and_return(aem_result('Agents retrieved', agent_names))
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready)
        .with({ _retries: { max_tries: nil, base_sleep_seconds: nil, max_sleep_seconds: nil } }).exactly(agent_names.size).times
        .and_return(aem_result('Package Manager ready'))
      agent_names.each do |agent_name|
        agent = instance_double(RubyAem::Resources::ReplicationAgent)
        allow(aem).to receive(:replication_agent).with('author', agent_name).and_return(agent)
        expect(agent).to receive(:delete).and_return(aem_result("Replication agent #{agent_name} deleted"))
      end
      resource.property(:ensure).sync
    end
  end

  context 'with the 03 scenario (packages_listed)' do
    let(:resource) do
      build_resource(:aem_aem, 'List packages by groups', ensure: 'packages_listed', run_mode: 'author', package_groups: ['shinesolutions'])
    end

    # The packages are those of the spec/acceptance scenarios; none of them is in the shinesolutions group
    it 'prints only packages of the listed groups, after a readiness check' do
      packages = [
        { 'group' => 'somepackagegroup', 'name' => 'somepackage', 'version' => '1.2.3' },
        { 'group' => 'somepackagegroup', 'name' => 'somearchivedpackage', 'version' => '1.2.3' },
      ]
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).ordered.and_return(aem_result('Package Manager ready'))
      expect(aem_instance).to receive(:get_packages).ordered.and_return(aem_result('All packages list retrieved successfully', packages))
      expect { resource.property(:ensure).sync }.not_to output.to_stdout
    end
  end

  context 'with the 01c scenario (aem_package_manager_is_ready)' do
    let(:resource) { build_resource(:aem_aem, 'Wait until CRX Package Manager is ready', ensure: 'aem_package_manager_is_ready', **retry_params) }

    it 'waits until the Package Manager is ready, with the retries' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with({ _retries: retries })
                                                                                           .and_return(aem_result('Package Manager ready'))
      resource.property(:ensure).sync
    end
  end
end
