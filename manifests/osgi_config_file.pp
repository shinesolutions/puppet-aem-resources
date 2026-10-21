# == Define: aem_resources::osgi_config_file
#
# Creates an OSGI configuration file in the install folder.
#
# Ported from aem::osgi::config::file in bstopp/aem 3.0.0 (Apache-2.0, Copyright (C) 2015-2016 Bryan Stopp)
# because that module is unmaintained and incompatible with OpenVox 9; see NOTICE.
# Only the 'file' type of aem::osgi::config is ported because it is the only one used here.
#
define aem_resources::osgi_config_file (
  # Data types replace the validate_re/validate_absolute_path/is_hash checks of the aem::osgi::config
  # wrapper (stdlib functions removed in stdlib 9) that callers used to go through
  Enum['present', 'absent'] $ensure,
  $group,
  Stdlib::Absolutepath $home,
  $pid,
  Hash $properties,
  $user
) {
  if $pid == undef {
    $_pid = $name
  } else {
    $_pid = $pid
  }

  $file_props = {
    'properties' => $properties,
    'pid'        => $_pid,
  }

  file { "${home}/crx-quickstart/install/${_pid}.config" :
    ensure  => $ensure,
    group   => $group,
    content => epp("${module_name}/osgi.config.epp", $file_props),
    mode    => '0664',
    owner   => $user,
  }

  if defined(File[$home]) {
    File[$home]
    -> File["${home}/crx-quickstart/install/${_pid}.config"]
  }
}
