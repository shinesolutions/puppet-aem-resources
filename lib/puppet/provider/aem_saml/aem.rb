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
    # SAMLUPDATE
    ############################################################
    # Caution:
    # Whenever new SAML options are available in AEM, we need
    # to add them here according to the type of the value.
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
    # SAML configuration.
    #
    # OSGI config alone is not enough to enable SAML in AEM.
    # Therefore we need to set it via /system/console/configMgr
    # again as well. But we are only setting those options
    # we already set via osgi config.
    ############################################################
    property_params = {}
    propertylist = []

    # We need to interate through all SAML options,
    # but we only want to set those which are set
    # in the osgi config.
    string_property.each { |item|
      property_is_set = saml_properties.send(item.to_sym).is_set
      # The item name has to be Java variable style
      # Therefore we are set the first letter after _ as uppercase
      # and we remove _ e.g. key_store_password to keyStorePassword
      property_list_item = item.gsub(/_[a-z]/) { $&.upcase }.delete('_')
      propertylist.push(property_list_item) if property_is_set.eql?(true)
      property_params[item.to_sym] = saml_properties.send(item.to_sym).value if property_is_set.eql?(true)
    }
    string_multi_property.each { |item|
      property_is_set = saml_properties.send(item.to_sym).is_set
      # The item name has to be Java variable style
      # Therefore we are set the first letter after _ as uppercase
      # and we remove _ e.g. default_groups to defaultGroups
      property_list_item = item.gsub(/_[a-z]/) { $&.upcase }.delete('_')
      propertylist.push(property_list_item) if property_is_set.eql?(true)
      property_params[item.to_sym] = saml_properties.send(item.to_sym).values if property_is_set.eql?(true)
    }
    boolean_property.each { |item|
      property_is_set = saml_properties.send(item.to_sym).is_set
      # The item name has to be Java variable style
      # Therefore we are set the first letter after _ as uppercase
      # and we remove _
      # e.g. handle_logout to handleLogout
      property_list_item = item.gsub(/_[a-z]/) { $&.upcase }.delete('_')
      propertylist.push(property_list_item) if property_is_set.eql?(true)
      property_params[item.to_sym] = saml_properties.send(item.to_sym).value if property_is_set.eql?(true)
    }
    long_property.each { |item|
      property_is_set = saml_properties.send(item.to_sym).is_set
      # The item name has to be Java variable style
      # Therefore we are set the first letter after _ as uppercase
      # and we remove _ e.g. clock_tolerance to clockTolerance
      # Except for service_ranking, as it has a . isntead of nothing
      property_list_item = item.gsub(/_[a-z]/) { $&.upcase }.delete('_') unless item.eql?('service_ranking')
      property_list_item = item.tr('_', '.') if item.eql?('service_ranking')
      propertylist.push(property_list_item) if property_is_set.eql?(true)
      property_params[item.to_sym] = saml_properties.send(item.to_sym).value if property_is_set.eql?(true)
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

    saml_properties.idp_cert_alias.is_set
  end
end
