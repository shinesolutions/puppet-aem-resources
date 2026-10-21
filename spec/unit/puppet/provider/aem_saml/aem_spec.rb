# frozen_string_literal: true

require 'spec_helper'
require_relative '../provider_spec_helpers'

# Unit tests for the aem_saml provider: the ruby_aem calls it makes and the SAML properties it builds,
# with the ruby_aem client stubbed, AEM's SAML configuration as real swagger_aem_osgi models and the
# IdP certificate read from spec/acceptance/fixtures/saml.crt. Values are those of
# spec/acceptance/resources/55 and 63. Whether AEM applies the configuration needs `make test-integration`.
describe Puppet::Type.type(:aem_saml).provider(:aem) do
  let(:aem) { instance_double(RubyAem::Aem) }
  let(:aem_instance) { instance_double(RubyAem::Resources::Aem) }
  let(:saml) { instance_double(RubyAem::Resources::Saml) }
  let(:provider) { resource.provider }

  # AEM's current SAML configuration, as ruby_aem's Saml#get returns it
  def saml_configuration(idp_cert_alias_is_set)
    properties = SwaggerAemOsgiClient::ComAdobeGraniteAuthSamlSamlAuthenticationHandlerProperties.new(
      idp_cert_alias: SwaggerAemOsgiClient::ConfigNodePropertyString.new(is_set: idp_cert_alias_is_set),
    )
    body = SwaggerAemOsgiClient::ComAdobeGraniteAuthSamlSamlAuthenticationHandlerInfo.new(properties: properties)
    RubyAem::Result.new('SAML Configuration found', RubyAem::Response.new(200, body, {}))
  end

  before(:each) do
    allow(RubyAem::Aem).to receive(:new).and_return(aem)
    allow(aem).to receive_messages(aem: aem_instance, saml: saml)
  end

  context 'with the 55 scenario (present)' do
    let(:synchronize_attributes) do
      [
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email',
      ]
    end
    let(:saml_settings) do
      {
        key_store_password: 'somepassword',
        service_ranking: 5002,
        idp_http_redirect: true,
        create_user: true,
        default_redirect_url: '/sites.html',
        user_id_attribute: 'NameID',
        default_groups: ['def-groups'],
        add_group_memberships: true,
        path: ['/'],
        synchronize_attributes: synchronize_attributes,
        clock_tolerance: 60,
        group_membership_attribute: 'http://temp/variable/aem-groups',
        idp_url: 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
        logout_url: 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
        service_provider_entity_id: 'https://prod-aemauthor.com/saml_login',
        handle_logout: true,
        use_encryption: false,
        name_id_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
        digest_method: 'http://www.w3.org/2001/04/xmlenc#sha256',
        signature_method: 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
      }
    end
    let(:resource) do
      build_resource(:aem_saml, 'Create SAML configuratoin',
                     ensure: 'present', file: '/tmp/shinesolutions/puppet-aem-resources/saml.crt', **saml_settings)
    end
    let(:certificate) { instance_double(RubyAem::Resources::Certificate) }
    # The alias AEM gave the IdP certificate in its truststore; ruby_aem's Certificate keeps it in @cert_alias
    let(:aem_assigned_alias) { 'alias assigned by AEM' }

    before(:each) do
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with('/tmp/shinesolutions/puppet-aem-resources/saml.crt').and_return(acceptance_fixture('saml.crt'))
      allow(aem).to receive(:certificate).with(18_165_092_276_682_983_468).and_return(certificate)
      certificate.instance_variable_set(:@cert_alias, aem_assigned_alias)
    end

    it "reports SAML as missing when AEM's configuration has no IdP certificate alias" do
      allow(saml).to receive(:get).and_return(saml_configuration(false))
      expect(provider.exists?).to be(false)
    end

    it 'sends the SAML settings with the IdP certificate alias from the truststore, after a readiness check' do
      sent = {}
      allow(certificate).to receive(:exists).and_return(aem_result('Certificate exists', true))
      allow(saml).to receive(:get).and_return(saml_configuration(false))
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(saml).to receive(:create).ordered do |property_params|
        sent = property_params
        aem_result('SAML Configuration created', nil, 302)
      end
      provider.create
      expect(sent).to include(saml_settings)
      expect(sent).to include(idp_cert_alias: aem_assigned_alias, post: false, apply: true, action: 'ajaxConfigManager', location: nil)
      expect(sent[:propertylist]).to include('keyStorePassword', 'service.ranking', 'idpCertAlias', 'defaultRedirectUrl', 'synchronizeAttributes')
    end

    it "also lists the resource's other parameters in propertylist, as it builds it from every parameter" do
      allow(certificate).to receive(:exists).and_return(aem_result('Certificate exists', true))
      allow(saml).to receive(:get).and_return(saml_configuration(false))
      allow(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).and_return(aem_result('Package Manager ready'))
      sent = {}
      allow(saml).to receive(:create) do |property_params|
        sent = property_params
        aem_result('SAML Configuration created', nil, 302)
      end
      provider.create
      expect(sent[:propertylist]).to include('provider', 'name', 'ensure', 'loglevel', 'file', 'configNodePath', 'configNodeName', 'nodeType')
    end

    it 'sends every SAML setting under a name ruby_aem passes on to AEM' do
      spec = YAML.load_file(File.join(Gem.loaded_specs['ruby_aem'].full_gem_path, 'conf', 'spec.yaml'))
      forwarded = spec.fetch('saml').fetch('actions').fetch('create').fetch('params').fetch('optional').map(&:to_sym)
      expect(saml_settings.keys + [:idp_cert_alias, :post, :apply, :action, :location, :propertylist] - forwarded).to be_empty
    end

    it 'does not configure SAML when the IdP certificate is not in the truststore' do
      allow(certificate).to receive(:exists).and_return(aem_result('Certificate not found', false))
      expect(saml).not_to receive(:create)
      expect(provider.create).to be(false)
    end
  end

  context 'with the 63 scenario (absent)' do
    let(:resource) { build_resource(:aem_saml, 'Remove SAML configuratoin', ensure: 'absent') }

    it 'waits for the Package Manager, then deletes the SAML configuration' do
      expect(aem_instance).to receive(:get_package_manager_servlet_status_wait_until_ready).with(unset_retries).ordered
                                                                                           .and_return(aem_result('Package Manager ready'))
      expect(saml).to receive(:delete).ordered.and_return(aem_result('SAML Configuration deleted', nil, 302))
      provider.destroy
    end
  end
end
