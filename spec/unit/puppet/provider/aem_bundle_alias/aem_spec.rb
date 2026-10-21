# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_bundle_alias provider: the ruby_aem calls its ensure values make, with the
# ruby_aem client stubbed. Values are those of spec/acceptance/resources/11 and
# spec/acceptance/manifests/40. Whether AEM starts or stops the bundle needs `make test-integration`.
describe Puppet::Type.type(:aem_bundle_alias).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:bundle) { instance_double(RubyAem::Resources::Bundle) }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:aem).and_return(aem_instance)
  end

  context 'with the 11 scenario (stopped)' do
    let(:resource) { build_resource(:aem_bundle_alias, 'Stop webdav bundle', ensure: 'stopped', name: 'org.apache.sling.jcr.webdav') }

    it 'stops the bundle, without the readiness check aem_bundle runs' do
      allow(aem).to receive(:bundle).with('org.apache.sling.jcr.webdav').and_return(bundle)
      expect(aem_instance).not_to receive(:get_package_manager_servlet_status_wait_until_ready)
      expect(bundle).to receive(:stop).and_return(aem_result('Bundle org.apache.sling.jcr.webdav stopped'))
      resource.property(:ensure).sync
    end

    it 'always reports the bundle as present, so it is stopped on every Puppet run' do
      expect(resource.provider.exists?).to be(true)
    end
  end

  context 'with the spec/acceptance/manifests/40 scenario (started)' do
    let(:resource) { build_resource(:aem_bundle_alias, 'Start davex bundle', ensure: 'started', name: 'org.apache.sling.jcr.davex') }

    it 'starts the bundle' do
      allow(aem).to receive(:bundle).with('org.apache.sling.jcr.davex').and_return(bundle)
      expect(bundle).to receive(:start).and_return(aem_result('Bundle org.apache.sling.jcr.davex started'))
      resource.property(:ensure).sync
    end
  end
end
