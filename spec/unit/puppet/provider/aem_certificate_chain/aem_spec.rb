# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_certificate_chain provider: the ruby_aem calls it makes, with the ruby_aem
# client stubbed. Values are those of spec/acceptance/resources/57 and 64.
# Whether AEM imports or deletes the certificate chain needs `make test-integration`.
describe Puppet::Type.type(:aem_certificate_chain).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:certificate_chain) { instance_double(RubyAem::Resources::CertificateChain) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive(:certificate_chain).with('somealias', '/home/users/system', 'authentication-service').and_return(certificate_chain)
  end

  context 'with the 57 scenario (present)' do
    let(:resource) do
      build_resource(:aem_certificate_chain, 'Add certificate chain to keystore for user authentication-service',
                     ensure: 'present', authorizable_id: 'authentication-service', intermediate_path: '/home/users/system',
                     private_key_alias: 'somealias', private_key_file_path: '/tmp/shinesolutions/puppet-aem-resources/private_key.der',
                     certificate_chain_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_chain.crt')
    end

    it 'asks AEM whether the private key alias exists in the keystore' do
      allow(certificate_chain).to receive(:exists).and_return(aem_result('Certificate chain not found', false))
      expect(provider.exists?).to be(false)
    end

    it 'imports the certificate chain and private key and waits until AEM has them, with the resource retries' do
      expect(certificate_chain).to receive(:import_wait_until_ready).with(
        '/tmp/shinesolutions/puppet-aem-resources/cert_chain.crt', '/tmp/shinesolutions/puppet-aem-resources/private_key.der', unset_retries
      ).and_return(aem_result('Certificate chain imported'))
      provider.create
    end
  end

  context 'with the 64 scenario (absent)' do
    let(:resource) do
      build_resource(:aem_certificate_chain, 'Remove certificate from keystore for user authentication-service',
                     ensure: 'absent', authorizable_id: 'authentication-service', intermediate_path: '/home/users/system',
                     private_key_alias: 'somealias')
    end

    it 'deletes the certificate chain' do
      expect(certificate_chain).to receive(:delete).and_return(aem_result('Certificate chain deleted'))
      provider.destroy
    end
  end
end
