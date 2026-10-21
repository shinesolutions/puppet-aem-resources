# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_node provider: the ruby_aem calls it makes, including the Package Manager
# readiness check, with the ruby_aem client stubbed. Values are those of spec/acceptance/resources/50 and 52.
# Whether AEM creates or deletes the node needs `make test-integration`.
describe Puppet::Type.type(:aem_node).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:node) { instance_double(RubyAem::Resources::Node) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
    allow(aem).to receive(:node).with('/apps/system/config', 'org.apache.felix.http').and_return(node)
  end

  context 'with the 50 scenario (present)' do
    let(:resource) do
      build_resource(:aem_node, 'Create http OSGI config node',
                     ensure: 'present', name: 'org.apache.felix.http', path: '/apps/system/config', type: 'sling:OsgiConfig')
    end

    it 'asks AEM whether the node exists' do
      allow(node).to receive(:exists).and_return(aem_result('Node org.apache.felix.http not found', false))
      expect(provider.exists?).to be(false)
    end

    it 'waits for the Package Manager, then creates the node with its type' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(node).to receive(:create).with('sling:OsgiConfig').ordered.and_return(aem_result('Node org.apache.felix.http created'))
      provider.create
    end
  end

  context 'with the 52 scenario (absent)' do
    let(:resource) do
      build_resource(:aem_node, 'Delete http OSGI config node', ensure: 'absent', name: 'org.apache.felix.http', path: '/apps/system/config')
    end

    it 'waits for the Package Manager, then deletes the node' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(node).to receive(:delete).ordered.and_return(aem_result('Node org.apache.felix.http deleted'))
      provider.destroy
    end
  end
end
