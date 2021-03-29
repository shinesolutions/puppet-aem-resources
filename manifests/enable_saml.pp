define aem_resources::enable_saml(
  $add_group_memberships          = true,
  $aem_id                         = 'author',
  $aem_username                   = undef,
  $aem_password                   = undef,
  $assertion_consumer_service_url = undef,
  $clock_tolerance                = 60,
  $create_user                    = true,
  $default_groups                 = undef,
  $default_redirect_url           = '/',
  $digest_method                  = 'http://www.w3.org/2001/04/xmlenc#sha256',
  $file                           = undef,
  $force                          = false,
  $group_membership_attribute     = 'groupMembership',
  $handle_logout                  = false,
  $idp_cert_alias                 = undef,
  $idp_http_redirect              = false,
  $idp_url                        = undef,
  $key_store_password             = 'unmodified',
  $logout_url                     = undef,
  $name_id_format                 = 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
  $path                           = ['/'],
  $serial                         = undef,
  $service_provider_entity_id     = undef,
  $service_ranking                = 5002,
  $signature_method               = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
  $sp_private_key_alias           = undef,
  $synchronize_attributes         = undef,
  $tmp_dir                        = '/tmp',
  $use_encryption                 = true,
  $user_id_attribute              = 'uid',
  $user_intermediate_path         = undef,
) {
    $default_params_enable_saml = {
      ensure                         => present,
      add_group_memberships          => $add_group_memberships,
      aem_id                         => $aem_id,
      aem_username                   => $aem_username,
      aem_password                   => $aem_password,
      assertion_consumer_service_url => $assertion_consumer_service_url,
      clock_tolerance                => $clock_tolerance,
      create_user                    => $create_user,
      default_groups                 => $default_groups,
      default_redirect_url           => $default_redirect_url,
      digest_method                  => $digest_method,
      force                          => $force,
      group_membership_attribute     => $group_membership_attribute,
      handle_logout                  => $handle_logout,
      idp_cert_alias                 => $idp_cert_alias,
      idp_http_redirect              => $idp_http_redirect,
      idp_url                        => $idp_url,
      logout_url                     => $logout_url,
      key_store_password             => $key_store_password,
      name_id_format                 => $name_id_format,
      path                           => $path,
      service_provider_entity_id     => $service_provider_entity_id,
      service_ranking                => $service_ranking,
      signature_method               => $signature_method,
      sp_private_key_alias           => $sp_private_key_alias,
      synchronize_attributes         => $synchronize_attributes,
      use_encryption                 => $use_encryption,
      user_id_attribute              => $user_id_attribute,
      user_intermediate_path         => $user_intermediate_path,
    }

    if $file {
      archive { "${tmp_dir}/SAML/saml_certificate.crt":
        ensure => present,
        source => $file,
        before => Aem_saml[aem_saml]
      }

      $params_enable_saml = {
        aem_saml => {
          file => "${tmp_dir}/SAML/saml_certificate.crt"
        }
      }
    } elsif $idp_cert_alias {
      $params_enable_saml = {
        aem_saml => {
          idp_cert_alias => $idp_cert_alias
        }
      }
    } elsif $serial {
      $params_enable_saml = {
        aem_saml => {
          serial => $serial
        }
      }
    }

    # Creating a new variable from the SAML idp_url to get the idp hostname
    # for configuring the ReferrerFilter
    $idp_hostname_regexp = regsubst($idp_url, '\b\/.*$', '')
    $idp_hostname_regexp2 = regsubst($idp_hostname_regexp, 'http.:\/\/', '')

    $idp_hostname = $idp_hostname_regexp2

    create_resources(
      aem_saml,
      $params_enable_saml,
      $default_params_enable_saml
    )

    aem_node { "${aem_id}: Create Apache Sling Referrer Filter config node":
      ensure  => present,
      name    => 'org.apache.sling.security.impl.ReferrerFilter',
      path    => '/apps/system/config',
      type    => 'sling:OsgiConfig',
      aem_id  => $aem_id,
      require => Aem_saml[aem_saml]
    } -> aem_config_property { "${aem_id}: allow empty referrer":
      ensure           => present,
      name             => 'allow.empty',
      type             => 'Boolean',
      value            => true, # False or true ? Def OpenCloud False SAML package is true
      run_mode         => $aem_id,
      aem_id           => $aem_id,
      config_node_name => 'org.apache.sling.security.impl.ReferrerFilter',
    } -> aem_config_property { "${aem_id}: Set allowed methods":
      ensure           => present,
      name             => 'filter.methods',
      type             => 'String[]',
      value            => ['POST', 'PUT', 'DELETE'],
      run_mode         => $aem_id,
      aem_id           => $aem_id,
      config_node_name => 'org.apache.sling.security.impl.ReferrerFilter',
    } -> aem_config_property { "${aem_id}: Set allowed hosts":
      ensure           => present,
      name             => 'allow.hosts',
      type             => 'String[]',
      value            => [$idp_hostname],
      run_mode         => $aem_id,
      aem_id           => $aem_id,
      config_node_name => 'org.apache.sling.security.impl.ReferrerFilter',
    }

    if $file {
      # Remove created SAML certificate
      exec { "${aem_id}: Clean SAML certificate":
        command => "rm -rf ${tmp_dir}/SAML/saml_certificate.crt",
        path    => ['/usr/bin', '/usr/sbin', '/bin'],
        require => Aem_saml[aem_saml]
      }
    }
  }
