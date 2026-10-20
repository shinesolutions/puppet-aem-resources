# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_outbox_replication_agent provider: the ruby_aem calls it makes and their
# arguments, including the Package Manager readiness check it runs first, with the ruby_aem client
# stubbed. Values are those of spec/acceptance/resources/24 and 25, which set no retries_* values.
# Whether AEM accepts these calls needs a running AEM: see `make test-integration`.
describe Puppet::Type.type(:aem_outbox_replication_agent).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:outbox_replication_agent) { instance_double(RubyAem::Resources::OutboxReplicationAgent) }
  let(:provider) { resource.provider }
  # call_with_readiness_check passes the resource's retries_* values, unset here
  let(:readiness_opts) { { _retries: { max_tries: nil, base_sleep_seconds: nil, max_sleep_seconds: nil } } }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
    allow(aem).to receive(:outbox_replication_agent).with('publish', 'some-outbox-replication-agent').and_return(outbox_replication_agent)
  end

  context 'with the 24 scenario (present, force)' do
    let(:resource) do
      build_resource(:aem_outbox_replication_agent, 'Create/update outbox replication agent',
                     ensure: 'present', name: 'some-outbox-replication-agent', run_mode: 'publish',
                     title: 'Some Outbox Replication Agent Title', description: 'Some outbox replication agent description',
                     dest_base_url: 'http://somehost:8080', user_id: 'someuser', log_level: 'info', force: true)
    end

    it 'waits for the Package Manager, then creates or updates the agent with the user ID and log level' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(readiness_opts).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(outbox_replication_agent).to receive(:create_update).with(
        'Some Outbox Replication Agent Title', 'Some outbox replication agent description', 'http://somehost:8080',
        { user_id: 'someuser', log_level: 'info' }
      ).ordered.and_return(aem_result('Outbox replication agent some-outbox-replication-agent created'))
      provider.create
    end

    it 'passes every option ruby_aem interpolates for create_update' do
      allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).and_return(aem_result('ready'))
      call_params = []
      allow(outbox_replication_agent).to receive(:create_update) do |_title, _description, _dest_base_url, opts|
        call_params = [:run_mode, :name, :title, :description, :dest_base_url] + opts.keys
        aem_result('created')
      end
      provider.create
      expect(ruby_aem_spec_keys('outboxreplicationagent', 'create_update') - call_params).to be_empty
    end

    it 'does not create the agent when the Package Manager readiness check fails' do
      allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).and_raise(StandardError, 'not ready')
      expect(outbox_replication_agent).not_to receive(:create_update)
      expect { provider.create }.to raise_error(StandardError, 'not ready')
    end

    it 'treats the agent as missing without asking AEM, so it is always created or updated' do
      expect(outbox_replication_agent).not_to receive(:exists)
      expect(provider.exists?).to be(false)
    end
  end

  context 'with the 25 scenario (absent)' do
    let(:resource) do
      build_resource(:aem_outbox_replication_agent, 'Delete outbox replication agent',
                     ensure: 'absent', name: 'some-outbox-replication-agent', run_mode: 'publish')
    end

    it 'asks AEM whether the agent exists' do
      allow(outbox_replication_agent).to receive(:exists).and_return(aem_result('Outbox replication agent exists', true))
      expect(provider.exists?).to be(true)
    end

    it 'waits for the Package Manager, then deletes the agent' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(readiness_opts).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(outbox_replication_agent).to receive(:delete).ordered.and_return(aem_result('Outbox replication agent deleted'))
      provider.destroy
    end
  end
end
