# Internal: manage the redis package

class redis::package(
  $ensure  = undef,

  $package = undef,
  $version = undef,
) {
  $real_ensure = $ensure ? {
    present => $version,
    default => absent,
  }

  package { $package:
    ensure => $real_ensure,
  }

  if $::operatingsystem == 'Darwin' {
    include boxen::config

    homebrew::formula { 'redis': }

    ->
    Package[$package]

    ->
    file {
      "${boxen::config::homebrewdir}/etc/redis.conf":
        ensure => absent ;

      "${boxen::config::homebrewdir}/var/db/redis":
        ensure  => absent,
        force   => true,
        recurse => true,
    }
  }

}
