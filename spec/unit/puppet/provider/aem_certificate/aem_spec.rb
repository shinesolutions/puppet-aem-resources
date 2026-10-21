# frozen_string_literal: true

require 'spec_helper'
require 'stringio'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_certificate provider: the ruby_aem calls it makes, with the ruby_aem client
# stubbed and the certificate file read from spec/acceptance/fixtures/saml.crt (serial
# 18165092276682983468). Values are those of spec/acceptance/resources/54, 59 and 66.
# Whether AEM imports, exports or deletes the certificate needs `make test-integration`.
describe Puppet::Type.type(:aem_certificate).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:certificate) { instance_double(RubyAem::Resources::Certificate) }
  let(:certificate_pem) { acceptance_fixture('saml.crt') }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
  end

  context 'with the 54 scenario (present, file)' do
    let(:resource) { build_resource(:aem_certificate, 'Add certificate by variable', ensure: 'present', file: '/tmp/shinesolutions/puppet-aem-resources/saml.crt') }

    before(:each) do
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with('/tmp/shinesolutions/puppet-aem-resources/saml.crt').and_return(certificate_pem)
      allow(aem).to receive(:certificate).with(18_165_092_276_682_983_468).and_return(certificate)
    end

    it "asks AEM whether the certificate with the file's serial number exists" do
      allow(certificate).to receive(:exists).and_return(aem_result('Certificate not found', false))
      expect(provider.exists?).to be(false)
    end

    it 'imports the file and waits until AEM has it, with the resource retries' do
      expect(certificate).to receive(:import_wait_until_ready).with('/tmp/shinesolutions/puppet-aem-resources/saml.crt', unset_retries)
                                                              .and_return(aem_result('Certificate imported'))
      provider.create
    end
  end

  context 'with the 59 scenario (archived)' do
    let(:resource) do
      build_resource(:aem_certificate, 'Export certificate by serial',
                     ensure: 'archived', serial: '18165092276682983468',
                     file: '/tmp/shinesolutions/puppet-aem-resources/saml_exported.crt', truststore_password: 'sometruststorepassword')
    end

    it 'exports the certificate with the truststore password and writes it to the file' do
      exported = OpenSSL::X509::Certificate.new(certificate_pem)
      written = StringIO.new
      allow(aem).to receive(:certificate).with('18165092276682983468').and_return(certificate)
      expect(certificate).to receive(:export).with('sometruststorepassword').and_return(aem_result('Certificate exported', exported))
      expect(File).to receive(:new).with('/tmp/shinesolutions/puppet-aem-resources/saml_exported.crt', 'w').and_return(written)
      provider.archive
      expect(written.string).to eq(exported.to_pem)
    end
  end

  context 'with the 66 scenario (absent)' do
    let(:resource) { build_resource(:aem_certificate, 'remove certificate by serial', ensure: 'absent', serial: '18165092276682983468') }

    before(:each) do
      allow(aem).to receive(:certificate).with('18165092276682983468').and_return(certificate)
    end

    it 'asks AEM whether the certificate exists' do
      allow(certificate).to receive(:exists).and_return(aem_result('Certificate exists', true))
      expect(provider.exists?).to be(true)
    end

    it 'deletes the certificate' do
      expect(certificate).to receive(:delete).and_return(aem_result('Certificate deleted'))
      provider.destroy
    end
  end
end
