# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_bundle provider: the ruby_aem calls its ensure values make, including the
# Package Manager readiness check, with the ruby_aem client stubbed. Values are those of
# spec/acceptance/resources/10 and 12. Whether AEM starts or stops the bundle needs `make test-integration`.
describe Puppet::Type.type(:aem_bundle).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:bundle) { instance_double(RubyAem::Resources::Bundle) }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
    allow(aem).to receive(:bundle).with('org.apache.sling.jcr.webdav').and_return(bundle)
  end

  context 'with the 10 scenario (stopped)' do
    let(:resource) { build_resource(:aem_bundle, 'Stop webdav bundle', ensure: 'stopped', name: 'org.apache.sling.jcr.webdav') }

    it 'waits for the Package Manager, then stops the bundle' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(bundle).to receive(:stop).ordered.and_return(aem_result('Bundle org.apache.sling.jcr.webdav stopped'))
      resource.property(:ensure).sync
    end

    it 'always reports the bundle as present, so it is stopped on every Puppet run' do
      expect(resource.provider.exists?).to be(true)
    end
  end

  context 'with the 12 scenario (started)' do
    let(:resource) { build_resource(:aem_bundle, 'Start webdav bundle', ensure: 'started', name: 'org.apache.sling.jcr.webdav') }

    it 'waits for the Package Manager, then starts the bundle' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(bundle).to receive(:start).ordered.and_return(aem_result('Bundle org.apache.sling.jcr.webdav started'))
      resource.property(:ensure).sync
    end
  end
end
