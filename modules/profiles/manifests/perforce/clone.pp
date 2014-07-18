class profiles::perforce::clone ( $user='build', $group='ath' ) {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  user { $user:
    ensure     => present,
    uid        => '1001',
    gid        => 'ath',
    home       => "/home/${user}",
    shell      => '/bin/bash',
    managehome => true,
    require    => Group[$group],
  }

  group { $group:
    ensure => 'present',
    gid    => '1003',
  }

  file { "/home/${user}":
    ensure  => directory,
    group   => $group,
    owner   => $user,
    mode    => 0700,
  }

  file { "/home/${user}/puppet_testing":
    ensure  => directory,
    group   => $group,
    owner   => $user,
    mode    => 0700,
  }

  package { 'p4':
    ensure   => 'installed',
    source   => 'http://cobbler200.athenahealth.com/LocalRepo/athena-6/RPMS/p4-2014.1.807760-1.x86_64.rpm',
    provider => 'rpm'
  }

  package { 'rubygem-rake': ensure => 'latest' }

  package { 'puppetlabs_spec_helper':
    ensure   => 'latest',
    provider => 'gem',
  }

  package { 'puppet-lint':
    ensure   => 'latest',
    provider => 'gem',
  }

  #vcsrepo { '/home/build/puppet_testing':
  #  ensure   => latest,
  #  provider => 'p4',
  #  p4config => '.p4config',
  #  source   => '//depot/quicksync/puppet/...',
  #  require  => Package["p4"],
  #}

  file { 'p4-build-puppettest.sh':
    ensure => 'file',
    source => 'puppet:///modules/profiles/scripts/p4-build-puppettest.sh',
    name   => '/tmp/p4-build-puppettest.sh'
  }

  exec { '/tmp/p4-build-puppettest.sh':
    user    => $user,
    require => [File['/tmp/p4-build-puppettest.sh'], Package['p4']],
    command => '/tmp/p4-build-puppettest.sh'
  }

  exec { 'p4sync':
    user        => $user,
    require     => Exec['/tmp/p4-build-puppettest.sh'],
    cwd         => "/home/${user}/puppet_testing",
    environment => ['P4CLIENT=build_puppettest'],
    command     => 'p4 sync -qf //depot/quicksync/...'
  }

}

