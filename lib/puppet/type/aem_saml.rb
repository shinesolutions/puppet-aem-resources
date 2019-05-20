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

Puppet::Type.newtype(:aem_saml) do
  ensurable do
    newvalue(:archived) do
      provider.archive
    end

    newvalue(:present) do
      if @resource.provider&.respond_to?(:create)
        @resource.provider.create
      else
        @resource.create
      end
      nil
    end

    newvalue(:exists) do
      if @resource.provider&.respond_to?(:exists?)
        @resource.provider.exists?
      else
        @resource.exists?
      end
      nil
    end

    newvalue(:absent) do
      if @resource.provider&.respond_to?(:destroy)
        @resource.provider.destroy
      else
        @resource.destroy
      end
      nil
    end
  end

  def self.title_patterns
    [[/^(.*)$/, [[:name, ->(x) { x }]]]]
  end

  newparam :name do
    isnamevar
    desc 'Title'
  end

  newparam :aem_id do
    isnamevar
    desc 'AEM instance ID'
  end

  newparam :aem_username do
    desc 'AEM username'
  end

  newparam :aem_password do
    desc 'AEM password'
  end

  newparam :key_store_password do
    desc 'The password of the key-store of the authentication-service system user.'
  end

  newparam :service_ranking do
    desc 'OSGi Framework Service Ranking value to indicate the order in which to call this service. This is an int value where higher values designate higher precedence. Default value is 0.'
  end

  newparam :idp_http_redirect do
    desc 'Use an HTTP Redirect to the IDP URL instead of sending an AuthnRequest-message to request credentials. Use this for IDP initiated authentication.'
  end

  newparam :create_user do
    desc 'Whether or not to autocreate nonexisting users in the repository.'
  end

  newparam :default_redirect_url do
    desc 'The default location to redirect to after successful authentication.'
  end

  newparam :user_id_attribute do
    desc 'The name of the attribute containing the user ID used to authenticate and create the user in the CRX repository. Leave empty to use the Subject:NameId.'
  end

  newparam :default_groups do
    desc 'A list of default CRX groups users are added to after successful authentication.'
  end

  newparam :idp_cert_alias do
    desc 'The alias of the IdPs certificate in the global truststore. If this property is empty the authentication handler is disabled.'
  end

  newparam :add_group_memberships do
    desc 'Whether or not a user should be automatically added to CRX groups after successful authentication.'
  end

  newparam :path do
    desc 'Repository path for which this authentication handler should be used by Sling.'
  end

  newparam :synchronize_attributes do
    desc 'A list of attribute mappings (in the format "attributename=path/relative/to/user/node") which should be stored in the repository on user-synchronization.'
  end

  newparam :clock_tolerance do
    desc 'Time tolerance in seconds to compensate clock skew between IDP and SP when validating Assertions.'
  end

  newparam :group_membership_attribute do
    desc 'The name of the attribute containing a list of CRX groups this user should be added to.'
  end

  newparam :idp_url do
    desc 'URL of the IDP where the SAML Authentication Request should be sent to. If this property is empty the authentication handler is disabled. (idpUrl)'
  end

  newparam :logout_url do
    desc 'URL of the IDP where the SAML Logout Request should be sent to. If this property is empty the authentication handler wont handle logouts.'
  end

  newparam :service_provider_entity_id do
    desc 'ID which uniquely identifies this service provider with the identity provider. If this property is empty the authentication handler is disabled.'
  end

  newparam :handle_logout do
    desc 'Whether or not logout (dropCredentials) requests will be processed by this handler.'
  end

  newparam :sp_private_key_alias do
    desc 'The alias of the SPs private key in the key-store of the authentication-service system user. If this property is empty the handler will not be able to sign or decrypt messages.'
  end

  newparam :use_encryption do
    desc 'Whether or not this authentication handler expects encrypted SAML assertions. If this is enabled the SPs private key must be provided in the key-store of the authentication-service system user (see SP Private Key Alias above).'
  end

  newparam :name_id_format do
    desc 'The value of the NameIDPolicy format parameter to send in the AuthnRequest message.'
  end

  newparam :digest_method do
    desc 'The digest algorithm to use when signing a SAML message.'
  end

  newparam :signature_method do
    desc 'The signature algorithm to use when signing a SAML message.'
  end

  newparam :user_intermediate_path do
    desc 'User intermediate path to store created users.'
  end

  newparam :assertion_consumer_service_url do
    desc 'The (optional) AssertionConsumerServiceURL attribute of an Authn request specifies the location to which a <Response> message MUST be sent to the requester.'
  end
  newparam :config_node_path do
    desc 'AEM Node Path'
    defaultto '/apps/system/config'
  end

  newparam :config_node_name do
    desc 'AEM node name'
    defaultto 'com.adobe.granite.auth.saml.SamlAuthenticationHandler.config'
  end

  newparam :node_type do
    desc 'AEM node type'
    defaultto 'sling:OsgiConfig'
  end

  newparam :file do
    desc 'File path to the SAML certification.'
  end

  newparam :serial do
    desc 'Serial number of the SAML certificate in the AEM Truststore'
  end

  newparam :retries_max_tries do
    desc 'Maximum number of tries'
    validate do |value|
      value = 60 if value == ''
    end
  end

  newparam :retries_base_sleep_seconds do
    desc 'Starting sleep duration in seconds'
    validate do |value|
      value = 2 if value == ''
    end
  end

  newparam :retries_max_sleep_seconds do
    desc 'Maximum sleep duration in seconds'
    validate do |value|
      value = 5 if value == ''
    end
  end
end
