# frozen_string_literal: true

require 'spec_helper'
require_relative '../../puppet/provider/provider_spec_helpers'

# Unit tests for the providers' shared base class: how it builds the ruby_aem client and how
# handle/handle_multi report ruby_aem results. The resource is that of spec/acceptance/resources/20;
# the ruby_aem client is stubbed. Talking to AEM needs `make test-integration`.
describe 'PuppetX::ShineSolutions::PuppetAemResources' do
  let(:resource) do
    build_resource(:aem_flush_agent, 'Create/update flush agent',
                   ensure: 'present', name: 'some-flush-agent', run_mode: 'author', title: 'Some Flush Agent Title',
                   description: 'Some flush agent description', dest_base_url: 'http://somehost:8080',
                   log_level: 'info', retry_delay: 60_000, force: true)
  end
  let(:provider) { resource.provider }
  let(:result) { aem_result('Flush agent some-flush-agent created', nil, 200, 'some response body') }

  describe '#client' do
    it 'passes no settings when the resource, environment and config file set none, so ruby_aem uses its defaults' do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with(%r{\Aaem_}).and_return(nil)
      expect(RubyAem::Aem).to receive(:new).with({}).and_return(instance_double(RubyAem::Aem))
      provider.client(resource)
    end
  end

  describe '#handle' do
    it "logs the result's message at info level and the response at debug level" do
      allow(Puppet).to receive(:debug)
      expect(Puppet).to receive(:debug).with(%r{Response status code: 200})
      expect(Puppet).to receive(:debug).with(%r{Response body:\nsome response body})
      expect(Puppet).to receive(:info).with(%r{Flush agent some-flush-agent created\z})
      provider.handle(result)
    end

    it 'does not log a response or message the result does not have' do
      expect(Puppet).not_to receive(:debug)
      expect(Puppet).not_to receive(:info)
      provider.handle(RubyAem::Result.new(nil, nil))
    end

    it 'prefixes the message with [puppet-aem-resources]' do
      pending '@label is only set on the base class, so the providers log the message without the prefix (TODO in puppet_aem_resources.rb)'
      allow(Puppet).to receive(:debug)
      expect(Puppet).to receive(:info).with('[puppet-aem-resources] Flush agent some-flush-agent created')
      provider.handle(result)
    end
  end

  describe '#handle_multi' do
    it 'handles each result' do
      other = aem_result('Flush agent some-flush-agent updated')
      expect(provider).to receive(:handle).with(result).ordered
      expect(provider).to receive(:handle).with(other).ordered
      provider.handle_multi([result, other])
    end
  end
end
