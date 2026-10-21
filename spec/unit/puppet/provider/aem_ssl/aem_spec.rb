# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_ssl provider: the ruby_aem calls it makes and their arguments, including the
# Package Manager readiness check, with the ruby_aem client stubbed. Values are those of
# spec/acceptance/resources/61 and 62 and of aem_resources::author_publish_enable_ssl as the
# spec/acceptance/manifests/44 scenario declares it. Whether AEM enables SSL needs `make test-integration`.
describe Puppet::Type.type(:aem_ssl).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:ssl) { instance_double(RubyAem::Resources::Ssl) }
  let(:provider) { resource.provider }

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive_messages(aem: aem_instance, ssl: ssl)
  end

  context 'with the 61 scenario (present)' do
    let(:resource) do
      build_resource(:aem_ssl, 'Enable Granite SSL Config',
                     ensure: 'present', https_hostname: 'localhost', https_port: 5432,
                     keystore_password: 'somekeystorepassword', truststore_password: 'sometruststorepassword',
                     privatekey_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.der',
                     certificate_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.crt')
    end
    let(:enable_opts) do
      {
        keystore_password: 'somekeystorepassword', truststore_password: 'sometruststorepassword',
        https_hostname: 'localhost', https_port: 5432,
        certificate_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.crt',
        privatekey_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.der',
      }
    end

    it 'asks AEM whether SSL is enabled' do
      allow(ssl).to receive(:is_enabled).and_return(aem_result('HTTPS has been configured on port 5432', true))
      expect(provider.exists?).to be(true)
    end

    it 'waits for the Package Manager, then enables SSL with the certificates and passwords, without disabling it first' do
      expect(ssl).not_to receive(:disable)
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(ssl).to receive(:enable_wait_until_ready).with({ **enable_opts, **unset_retries }).ordered
                                                      .and_return(aem_result('SSL enabled'))
      provider.create
    end

    it 'passes every option ruby_aem interpolates for enable' do
      # ruby_aem's Ssl#enable sets the *_passwordConfirm values from the passwords itself
      derived = [:keystore_passwordConfirm, :truststore_passwordConfirm]
      expect(ruby_aem_spec_keys('ssl', 'enable') - derived - enable_opts.keys).to be_empty
    end
  end

  context 'with the 44 scenario (aem_resources::author_publish_enable_ssl, force)' do
    let(:resource) do
      build_resource(:aem_ssl, '[author]  ] SSL by default for AEM',
                     ensure: 'present', aem_id: 'author', force: true, https_hostname: 'localhost', https_port: 5435,
                     keystore_password: 'somekeystorepassword', truststore_password: 'sometruststorepassword',
                     privatekey_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.der',
                     certificate_file_path: '/tmp/shinesolutions/puppet-aem-resources/cert_ssl.crt')
    end

    it 'treats SSL as disabled without asking AEM' do
      expect(ssl).not_to receive(:is_enabled)
      expect(provider.exists?).to be(false)
    end

    it 'disables SSL, then enables it again' do
      allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).and_return(aem_result('Package Manager ready'))
      expect(ssl).to receive(:disable).ordered.and_return(aem_result('SSL disabled'))
      expect(ssl).to receive(:enable_wait_until_ready).with(hash_including(https_port: 5435)).ordered.and_return(aem_result('SSL enabled'))
      provider.create
    end
  end

  context 'with the 62 scenario (absent)' do
    let(:resource) { build_resource(:aem_ssl, 'Remove Granite SSL Config', ensure: 'absent') }

    it 'disables SSL, without a readiness check' do
      expect(aem_instance).not_to receive(:get_package_manager_servlet_status_wait_until_ready)
      expect(ssl).to receive(:disable).and_return(aem_result('SSL disabled'))
      provider.destroy
    end
  end
end
