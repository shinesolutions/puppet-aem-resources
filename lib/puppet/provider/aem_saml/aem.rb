# frozen_string_literal: true

# Copyright 2016-2019 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative '../../../puppet_x/shinesolutions/puppet_aem_resources.rb'

Puppet::Type.type(:aem_saml).provide(:aem, parent: PuppetX::ShineSolutions::PuppetAemResources) do
  # Create the AEM SAML Configuration.
  def create
    results = []
    ############################################################
    # Parameters are needed in order to create the osgi:config
    ############################################################
    string_property = %w[key_store_password default_redirect_url idp_cert_alias group_membership_attribute idp_url logout_url service_provider_entity_id sp_private_key_alias name_id_format user_id_attribute digest_method signature_method assertion_consumer_service_url user_intermediate_path]
    string_multi_property = %w[default_groups synchronize_attributes path]
    boolean_property = %w[handle_logout use_encryption idp_http_redirect add_group_memberships create_user]
    long_property = %w[service_ranking clock_tolerance]

    ############################################################
    # Getting idp_cert_alias from truststore if not provided
    ############################################################
    unless resource[:idp_cert_alias]
      if resource[:serial]
        serial_number = resource[:serial]
      elsif resource[:file]
        certificate_raw = File.read resource[:file]
        certificate_infos = OpenSSL::X509::Certificate.new(certificate_raw)
        serial_number = certificate_infos.serial.to_i
      end

      certificate = client(resource).certificate(serial_number)
      return false if certificate.exists.data.eql? false

      resource[:idp_cert_alias] = certificate.instance_variable_get(:@cert_alias)
    end

    ############################################################
    # before we can create the SAML configuration we need
    # create the osgi node
    ############################################################
    node = client(resource).node(resource[:config_node_path], resource[:config_node_name])
    results.push(call_with_readiness_check(node, 'create', [resource[:node_type]], resource))

    ############################################################
    # before creating the SAML configuration we need to add
    # osgi:config parameters to the previously created node
    ############################################################
    resource.to_hash.each do |(key, value)|
      if string_property.include? key.to_s
        type = 'String'

        config_property = client(resource).config_property(key.to_s, type, value)
        results.push(call_with_readiness_check(config_property, 'create', [resource[:config_node_name]], resource))
      elsif string_multi_property.include? key.to_s
        type = 'String[]'

        config_property = client(resource).config_property(key.to_s, type, value)
        results.push(call_with_readiness_check(config_property, 'create', [resource[:config_node_name]], resource))
      elsif boolean_property.include? key.to_s
        type = 'Boolean'

        config_property = client(resource).config_property(key.to_s, type, value)
        results.push(call_with_readiness_check(config_property, 'create', [resource[:config_node_name]], resource))
      elsif long_property.include? key.to_s
        type = 'Long'

        config_property = client(resource).config_property(key.to_s, type, value)
        results.push(call_with_readiness_check(config_property, 'create', [resource[:config_node_name]], resource))
      end
    end

    ############################################################
    # Checking if the parameters config properties set before
    # are setted by using the local method exists?
    #
    # To-Do:
    # To not end in a endless loop we need to add retry check
    ############################################################
    retries_count = 0
    while exists?.eql? false
      puts format('Wait until SAML configuration exists, check attempt #%<retries_count>d', retries_count: retries_count)
      sleep 10
    end

    saml = client(resource).saml
    saml_response = saml.get.response
    saml_response_body = saml_response.body
    saml_properties = saml_response_body.properties

    ############################################################
    # Building property parameters to create the actual
    # SAML configuration
    ############################################################
    property_params = {}
    propertylist = []

    saml_properties.each { |item|
      property_name = item.first
      propertylist.push(property_name)
      property_is_set = saml_properties[property_name][:is_set]
      property_name_api = :path if property_name.eql? :path
      property_name_api = :service_ranking if property_name.eql? :'service.ranking'
      property_name_api = :idp_url if property_name.eql? :idpUrl
      property_name_api = :idp_cert_alias if property_name.eql? :idpCertAlias
      property_name_api = :idp_http_redirect if property_name.eql? :idpHttpRedirect
      property_name_api = :service_provider_entity_id if property_name.eql? :serviceProviderEntityId
      property_name_api = :assertion_consumer_service_url if property_name.eql? :assertionConsumerServiceURL
      property_name_api = :sp_private_key_alias if property_name.eql? :spPrivateKeyAlias
      property_name_api = :key_store_password if property_name.eql? :keyStorePassword
      property_name_api = :default_redirect_url if property_name.eql? :defaultRedirectUrl
      property_name_api = :user_id_attribute if property_name.eql? :userIDAttribute
      property_name_api = :use_encryption if property_name.eql? :useEncryption
      property_name_api = :create_user if property_name.eql? :createUser
      property_name_api = :add_group_memberships if property_name.eql? :addGroupMemberships
      property_name_api = :group_membership_attribute if property_name.eql? :groupMembershipAttribute
      property_name_api = :default_groups if property_name.eql? :defaultGroups
      property_name_api = :name_id_format if property_name.eql? :nameIdFormat
      property_name_api = :synchronize_attributes if property_name.eql? :synchronizeAttributes
      property_name_api = :handle_logout if property_name.eql? :handleLogout
      property_name_api = :logout_url if property_name.eql? :logoutUrl
      property_name_api = :clock_tolerance if property_name.eql? :clockTolerance
      property_name_api = :digest_method if property_name.eql? :digestMethod
      property_name_api = :signature_method if property_name.eql? :signatureMethod
      property_name_api = :user_intermediate_path if property_name.eql? :userIntermediatePath

      property_params[property_name_api] = saml_properties[property_name][:values] || saml_properties[property_name][:value] if property_is_set.eql? true
    }
    property_params[:post] = false
    property_params[:apply] = true
    property_params[:action] = 'ajaxConfigManager'
    property_params[:location] = saml_response_body.bundle_location if saml_response_body.respond_to?(:bundle_location)
    property_params[:propertylist] = propertylist

    ############################################################
    # Create SAML configuration
    ############################################################
    results.push(call_with_readiness_check(saml, 'create', [property_params], resource))

    handle_multi(results)
  end

  # Delete the SAML Configuration file.
  def destroy
    results = []

    node = client(resource).node(resource[:config_node_path], resource[:config_node_name])
    results.push(call_with_readiness_check(node, 'delete', [], resource))

    saml = client(resource).saml
    results.push(call_with_readiness_check(saml, 'delete', [], resource))

    handle_multi(results)
  end

  # Check whether the SAML Configuration exists or not.
  def exists?
    saml = client(resource).saml
    result = saml.get

    saml_properties = result.response.body.properties

    saml_properties[:idpCertAlias][:is_set]
  end
end
