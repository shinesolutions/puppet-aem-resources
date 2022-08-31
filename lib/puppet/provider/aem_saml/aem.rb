# frozen_string_literal: true

# Copyright 2016-2021 Shine Solutions Group
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
    destroy if resource[:force].eql? true
    results = []
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

    saml = client(resource).saml
    saml_response = saml.get.response
    saml_response_body = saml_response.body

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
    resource.to_hash.each do |(key, value)|
      property_list_item = key.to_s.gsub(/_[a-z]/) { $&.upcase }.delete('_') unless key.to_s.eql?('service_ranking')
      property_list_item = key.to_s.tr('_', '.') if key.to_s.eql?('service_ranking')
      property_list_item = property_list_item.gsub('Url', 'URL') if key.to_s.eql?('assertion_consumer_service_url')

      propertylist.push(property_list_item)
      property_params[key.to_sym] = value
    end
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
    saml = client(resource).saml
    result = call_with_readiness_check(saml, 'delete', [], resource)

    handle(result)
  end

  # Check whether the SAML Configuration exists or not.
  def exists?
    return false if resource[:force].eql? true

    saml = client(resource).saml
    result = saml.get

    saml_properties = result.response.body.properties
    saml_properties.idp_cert_alias.is_set
  end
end
