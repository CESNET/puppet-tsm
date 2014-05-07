# == Class: tsm::packages
#
# install tsm packages and set package dependencies for solaris
#
# === Authors
#
# Toni Schmidbauer <toni@stderr.at>
#
# === Copyright
#
# Copyright 2013 Toni Schmidbauer
#
class tsm::install inherits tsm {
  tsm::installpkg { $::tsm::packages:
    ensure    => $::tsm::package_ensure,
    uri       => $::tsm::package_uri,
    adminfile => $::tsm::package_adminfile,
  }

  case $::osfamily {
    solaris: {
      case $::hardwareisa {
        i386: {
          Package['gsk8cry32'] ->
          Package['gsk8ssl32'] ->
          Package['gsk8cry64'] ->
          Package['gsk8ssl64'] ->
          Package['TIVsmCapi'] ->
          Package['TIVsmCba']
        }
        sparc: {
          Package['gsk8cry64'] ->
          Package['gsk8ssl64'] ->
          Package['TIVsmCapi'] ->
          Package['TIVsmCba']
        }
        default: {
          fail("Unsupported hardwareisa ${::hardwareisa} for osfamily ${::osfamily} in install.pp!")
        }
      }
    }
    default: {}
  }
}
