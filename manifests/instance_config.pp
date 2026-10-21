# == Define: aem_resources::instance_config
#
# Configure the AEM instance with the appropriate parameter values.
#
# Ported from aem::config in bstopp/aem 3.0.0 (Apache-2.0, Copyright (C) 2015-2016 Bryan Stopp)
# because that module is unmaintained and incompatible with OpenVox 9; see NOTICE.
#
define aem_resources::instance_config (
  $context_root,
  $debug_port,
  $group,
  $home,
  $jvm_mem_opts,
  $jvm_opts,
  $osgi_configs,
  $crx_packages,
  $port,
  $runmodes,
  $sample_content,
  $type,
  $user
) {
  File {
    group => $group,
    owner => $user,
  }

  # Create the env script
  file { "${home}/crx-quickstart/bin/start-env":
    ensure  => file,
    content => epp("${module_name}/start-env.epp", {
      context_root   => $context_root,
      debug_port     => $debug_port,
      jvm_mem_opts   => $jvm_mem_opts,
      jvm_opts       => $jvm_opts,
      port           => $port,
      runmodes       => $runmodes,
      sample_content => $sample_content,
      type           => $type,
    }),
    mode    => '0775',
  }

  # Rename the original start script.
  file { "${home}/crx-quickstart/bin/start.orig":
    ensure  => file,
    replace => false,
    source  => "${home}/crx-quickstart/bin/start",
    mode    => '0775',
  }

  # Create the start script
  file { "${home}/crx-quickstart/bin/start":
    ensure  => file,
    content => epp("${module_name}/start.epp"),
    mode    => '0775',
    require => File["${home}/crx-quickstart/bin/start.orig"],
  }

  # Create the install folder in case there are any OSGi configurations; now or in the future
  file { "${home}/crx-quickstart/install" :
    ensure => directory,
    mode   => '0775',
  }

  if $osgi_configs {
    # Type match replaces stdlib is_array (removed in stdlib 9)
    if $osgi_configs =~ Array {
      $_osgi_configs = $osgi_configs
    } else {
      $_osgi_configs = [$osgi_configs]
    }

    $_osgi_configs.each | Hash $cfg | {
      $cfg.each | $key, $values | {
        if $values['properties'] {
          $_props = $values['properties']
          $_pid = $values['pid']
        } else {
          $_props = $values
          $_pid = undef
        }

        # Was aem::osgi::config with type => 'file' (whose ensure defaulted to 'present')
        aem_resources::osgi_config_file { $key :
          ensure     => 'present',
          group      => $group,
          home       => $home,
          pid        => $_pid,
          properties => $_props,
          user       => $user,
        }
      }
    }
  }

  if $crx_packages {
    $crx_packages.each | $pkg | {
      $_filename = basename($pkg)
      # Was aem::crx::package with type => 'file' (whose ensure defaulted to 'present')
      aem_resources::crx_package_file { "${home}/crx-quickstart/install/${_filename}" :
        ensure => 'present',
        group  => $group,
        home   => $home,
        source => $pkg,
        user   => $user,
      }
    }
  }
}
