# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_replication_agent provider: the ruby_aem calls it makes and their arguments,
# with the ruby_aem client stubbed. Values are those of spec/acceptance/resources/22 and 23.
# Whether AEM accepts these calls needs a running AEM: see `make test-integration`.
describe Puppet::Type.type(:aem_replication_agent).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:replication_agent) { instance_double(RubyAem::Resources::ReplicationAgent) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:replication_agent).with('author', 'some-replication-agent').and_return(replication_agent)
  end

  context 'with the 22 scenario (present, force)' do
    let(:resource) do
      build_resource(:aem_replication_agent, 'Create/update replication agent',
                     ensure: 'present', name: 'some-replication-agent', run_mode: 'author', title: 'Some replication Agent Title',
                     description: 'Some replication agent description', dest_base_url: 'http://somehost:8080',
                     transport_user: 'someuser', transport_password: 'somepass', log_level: 'info', retry_delay: 60_000, force: true)
    end

    it 'creates or updates the agent with the transport credentials, log level and retry delay' do
      expect(replication_agent).to receive(:create_update).with(
        'Some replication Agent Title', 'Some replication agent description', 'http://somehost:8080',
        { transport_user: 'someuser', transport_password: 'somepass', log_level: 'info', retry_delay: 60_000 }
      ).and_return(aem_result('Replication agent some-replication-agent created'))
      provider.create
    end

    it 'passes every option ruby_aem interpolates for create_update' do
      call_params = []
      allow(replication_agent).to receive(:create_update) do |_title, _description, _dest_base_url, opts|
        call_params = [:run_mode, :name, :title, :description, :dest_base_url, :ssl] + opts.keys
        aem_result('created')
      end
      provider.create
      expect(ruby_aem_spec_keys('replicationagent', 'create_update') - call_params).to be_empty
    end

    it 'treats the agent as missing without asking AEM, so it is always created or updated' do
      expect(replication_agent).not_to receive(:exists)
      expect(provider.exists?).to be(false)
    end
  end

  context 'with the 23 scenario (absent)' do
    let(:resource) do
      build_resource(:aem_replication_agent, 'Delete replication agent', ensure: 'absent', name: 'some-replication-agent', run_mode: 'author')
    end

    it 'asks AEM whether the agent exists' do
      allow(replication_agent).to receive(:exists).and_return(aem_result('Replication agent some-replication-agent not found', false))
      expect(provider.exists?).to be(false)
    end

    it 'deletes the agent' do
      expect(replication_agent).to receive(:delete).and_return(aem_result('Replication agent some-replication-agent deleted'))
      provider.destroy
    end
  end
end
