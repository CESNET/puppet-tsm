# == Class: tsm::config
#
# Configures the tsm client
#
# === Authors
#
# Toni Schmidbauer <toni@stderr.at>
#
# === Copyright
#
# Copyright 2013-2017 Toni Schmidbauer
#
class tsm::config {

  concat { $::tsm::config:
    ensure  => present,
    replace => $::tsm::config_replace,
    owner   => 'root',
    group   => $::tsm::rootgroup,
    mode    => '0644',
  }

  if $::tsm::config_template {
    contain tsm::config::full_template
  } else {
    contain tsm::config::stanzas
  }

  if $::tsm::config_opt_hash {
    file { $::tsm::config_opt:
      ensure  => file,
      replace => $::tsm::config_replace,
      owner   => 'root',
      group   => $::tsm::rootgroup,
      mode    => '0644',
      content => template($::tsm::config_opt_template),
    }
  }
  else {
    file { $::tsm::config_opt:
      ensure => present,
    }
  }
}
