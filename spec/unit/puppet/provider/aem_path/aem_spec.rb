# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_path provider: the ruby_aem calls it makes, with the ruby_aem client stubbed.
# Values are those of spec/acceptance/resources/34 and 35, which set no `path`.
# Whether AEM activates or deletes the path needs `make test-integration`.
describe Puppet::Type.type(:aem_path).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:path) { instance_double(RubyAem::Resources::Path) }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
  end

  context 'with the 34 scenario (is_activated)' do
    let(:resource) { build_resource(:aem_path, 'Activate /etc/designs/cloudservices/', ensure: 'is_activated', name: '/etc/designs/cloudservices/') }

    it 'activates the path, ignoring deactivated nodes and including unmodified ones' do
      allow(aem).to receive(:path).with('/etc/designs/cloudservices/').and_return(path)
      expect(path).to receive(:activate).with(true, false).and_return(aem_result('Path /etc/designs/cloudservices/ activated'))
      resource.property(:ensure).sync
    end
  end

  context 'with the 35 scenario (absent)' do
    let(:resource) { build_resource(:aem_path, 'Delete /etc/designs/inexisting-path/', ensure: 'absent', name: '/etc/designs/inexisting-path/') }

    before(:each) do
      allow(aem).to receive(:path).with('/etc/designs/inexisting-path/').and_return(path)
    end

    it 'reports the path as present without asking AEM, as no `path` is set' do
      expect(aem).not_to receive(:node)
      expect(resource.provider.exists?).to be(true)
    end

    it 'deletes the path' do
      pending 'destroy does nothing without `path`, and with it calls ruby_aem Path#delete(path), which takes no argument (TODO in the provider)'
      expect(path).to receive(:delete).and_return(aem_result('Path /etc/designs/inexisting-path/ deleted'))
      resource.provider.destroy
    end
  end
end
