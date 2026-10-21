# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_repository provider: the ruby_aem calls its ensure values make, with the
# ruby_aem client stubbed. Values are those of spec/acceptance/resources/30.
# Whether AEM blocks repository writes needs `make test-integration`.
describe Puppet::Type.type(:aem_repository).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:repository) { instance_double(RubyAem::Resources::Repository) }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:repository).and_return(repository)
  end

  context 'with the 30 scenario (writes_blocked)' do
    let(:resource) { build_resource(:aem_repository, 'Block repository writes', ensure: 'writes_blocked') }

    it 'blocks repository writes' do
      expect(repository).to receive(:block_writes).and_return(aem_result('Repository writes blocked'))
      resource.property(:ensure).sync
    end

    it 'always reports the repository as present, so the action runs on every Puppet run' do
      expect(resource.provider.exists?).to be(true)
    end
  end

  context 'with the 30 scenario (writes_unblocked)' do
    let(:resource) { build_resource(:aem_repository, 'Unblock repository writes', ensure: 'writes_unblocked') }

    it 'unblocks repository writes' do
      expect(repository).to receive(:unblock_writes).and_return(aem_result('Repository writes unblocked'))
      resource.property(:ensure).sync
    end
  end
end
