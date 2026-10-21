# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_flush_agent provider: the ruby_aem calls it makes and their arguments,
# with the ruby_aem client stubbed. Values are those of spec/acceptance/resources/20 and 21.
# Whether AEM accepts these calls needs a running AEM: see `make test-integration`.
describe Puppet::Type.type(:aem_flush_agent).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:flush_agent) { instance_double(RubyAem::Resources::FlushAgent) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:flush_agent).with('author', 'some-flush-agent').and_return(flush_agent)
  end

  context 'with the 20 scenario (present, force)' do
    let(:resource) do
      build_resource(:aem_flush_agent, 'Create/update flush agent',
                     ensure: 'present', name: 'some-flush-agent', run_mode: 'author', title: 'Some Flush Agent Title',
                     description: 'Some flush agent description', dest_base_url: 'http://somehost:8080',
                     log_level: 'info', retry_delay: 60_000, force: true)
    end

    it 'creates or updates the agent with alias_update false, which ruby_aem 4 requires' do
      expect(flush_agent).to receive(:create_update).with(
        'Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080',
        { alias_update: false, log_level: 'info', retry_delay: 60_000 }
      ).and_return(aem_result('Flush agent some-flush-agent created'))
      provider.create
    end

    it 'passes every option ruby_aem interpolates for create_update' do
      call_params = []
      allow(flush_agent).to receive(:create_update) do |_title, _description, _dest_base_url, opts|
        call_params = [:run_mode, :name, :title, :description, :dest_base_url, :ssl] + opts.keys
        aem_result('created')
      end
      provider.create
      expect(ruby_aem_spec_keys('flushagent', 'create_update') - call_params).to be_empty
    end

    it 'treats the agent as missing without asking AEM, so it is always created or updated' do
      expect(flush_agent).not_to receive(:exists)
      expect(provider.exists?).to be(false)
    end

    it 'fails when ruby_aem raises an error' do
      error = RubyAem::Error.new('Unexpected response', aem_result('Unexpected response', nil, 500))
      allow(flush_agent).to receive(:create_update).and_raise(error)
      expect { provider.create }.to raise_error(RubyAem::Error, 'Unexpected response')
    end
  end

  context 'with the 21 scenario (absent)' do
    let(:resource) do
      build_resource(:aem_flush_agent, 'Delete flush agent', ensure: 'absent', name: 'some-flush-agent', run_mode: 'author')
    end

    it 'asks AEM whether the agent exists' do
      allow(flush_agent).to receive(:exists).and_return(aem_result('Flush agent some-flush-agent exists', true))
      expect(provider.exists?).to be(true)
    end

    it 'deletes the agent' do
      expect(flush_agent).to receive(:delete).and_return(aem_result('Flush agent some-flush-agent deleted'))
      provider.destroy
    end
  end
end
