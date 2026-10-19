# == Define: aem_resources::crx_package_file
#
# Copies a package file to the AEM install folder.
#
# Ported from aem::crx::package::file in bstopp/aem 3.0.0 (Apache-2.0, Copyright (C) 2015-2016 Bryan Stopp)
# because that module is unmaintained and incompatible with OpenVox 9; see NOTICE.
# Only the 'file' type of aem::crx::package is ported because it is the only one used here.
#
define aem_resources::crx_package_file (
  # Data types replace the validate_re/validate_absolute_path checks of the aem::crx::package
  # wrapper (stdlib functions removed in stdlib 9) that callers used to go through
  Enum['present', 'absent'] $ensure,
  $group,
  Stdlib::Absolutepath $home,
  String $source,
  $user
) {
  # The wrapper only required an absolute source path when the package was not being removed
  if $ensure == 'present' {
    assert_type(Stdlib::Absolutepath, $source)
  }

  $_filename = basename($source)

  file { "${home}/crx-quickstart/install/${_filename}" :
    ensure => $ensure,
    group  => $group,
    source => $source,
    mode   => '0664',
    owner  => $user,
  }

  if defined(File[$home]) {
    File[$home]
    -> File["${home}/crx-quickstart/install/${_filename}"]
  }
}
