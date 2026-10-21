# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_config_property provider: the ruby_aem calls it makes, including the
# Package Manager readiness check, with the ruby_aem client stubbed. Values are those of
# spec/acceptance/resources/51. Whether AEM sets the property needs `make test-integration`.
describe Puppet::Type.type(:aem_config_property).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:config_property) { instance_double(RubyAem::Resources::ConfigProperty) }
  let(:resource) do
    build_resource(:aem_config_property, 'Do not allow empty referrer',
                   ensure: 'present', name: 'allow.empty', type: 'Boolean', value: false, run_mode: 'publish',
                   config_node_name: 'org.apache.sling.security.impl.ReferrerFilter')
  end
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
  end

  it 'waits for the Package Manager, then sets the property on the config node' do
    expect(aem).to receive(:config_property).with('allow.empty', 'Boolean', false).and_return(config_property)
    expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                         .and_return(aem_result('Package Manager ready'))
    # run_mode isn't passed on: ruby_aem 4's ConfigProperty#create has no run mode (TODO in the provider)
    expect(config_property).to receive(:create).with('org.apache.sling.security.impl.ReferrerFilter').ordered
                                               .and_return(aem_result('Set org.apache.sling.security.impl.ReferrerFilter config Boolean property allow.empty=false'))
    provider.create
  end

  it 'always reports the property as missing, so it is set on every Puppet run' do
    expect(aem).not_to receive(:config_property)
    expect(provider.exists?).to be(false)
  end
end
