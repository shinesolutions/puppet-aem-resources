# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_authorizable_keystore provider: the ruby_aem calls it makes and their
# arguments, with the ruby_aem client stubbed. Values are those of spec/acceptance/resources/56, 60 and 65.
# Whether AEM accepts these calls needs a running AEM: see `make test-integration`.
describe Puppet::Type.type(:aem_authorizable_keystore).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:keystore) { instance_double(RubyAem::Resources::AuthorizableKeystore) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:authorizable_keystore).with('/home/users/system', 'authentication-service').and_return(keystore)
  end

  context 'with the 56 scenario (present)' do
    let(:resource) do
      build_resource(:aem_authorizable_keystore, 'Create new keystore for user authentication-service',
                     ensure: 'present', authorizable_id: 'authentication-service', intermediate_path: '/home/users/system',
                     password: 'somekeystorepassword')
    end

    it 'asks AEM whether the keystore exists' do
      allow(keystore).to receive(:exists).and_return(aem_result('Authorizable keystore not found', false))
      expect(provider.exists?).to be(false)
    end

    it 'creates the keystore with its password' do
      expect(keystore).to receive(:create).with('somekeystorepassword').and_return(aem_result('Authorizable keystore created'))
      provider.create
    end
  end

  context 'with the 60 scenario (archived)' do
    let(:resource) do
      build_resource(:aem_authorizable_keystore, 'Archive keystore for user authentication-service',
                     ensure: 'archived', authorizable_id: 'authentication-service', intermediate_path: '/home/users/system',
                     path: '/tmp/shinesolutions/puppet-aem-resources')
    end

    it 'downloads the keystore to store.p12 in path' do
      expect(keystore).to receive(:download).with('/tmp/shinesolutions/puppet-aem-resources/store.p12')
                                            .and_return(aem_result('Authorizable keystore downloaded'))
      provider.archive
    end
  end

  context 'with the 65 scenario (absent)' do
    let(:resource) do
      build_resource(:aem_authorizable_keystore, 'Delete keystore for user authentication-service',
                     ensure: 'absent', authorizable_id: 'authentication-service', intermediate_path: '/home/users/system')
    end

    it 'asks AEM whether the keystore exists' do
      allow(keystore).to receive(:exists).and_return(aem_result('Authorizable keystore exists', true))
      expect(provider.exists?).to be(true)
    end

    it 'deletes the keystore' do
      expect(keystore).to receive(:delete).and_return(aem_result('Authorizable keystore deleted'))
      provider.destroy
    end
  end
end
