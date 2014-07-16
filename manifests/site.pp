node 'puppet.vagrant.local' {
  user { 'build':
    ensure     => present,
    uid        => '1001',
    gid        => 'ath',
    comment    => 'Build',
    home       => '/home/build',
    shell      => '/bin/bash',
    managehome => true,
    require    => Group['ath'],
  }

  group { 'ath':
    ensure => 'present',
    name   => 'ath',
    gid    => '1003',
  }

  package { 'p4':
    ensure   => 'installed',
    source   => 'http://cobbler200.athenahealth.com/LocalRepo/athena-6/RPMS/p4-2014.1.807760-1.x86_64.rpm',
    provider => 'rpm'
  }
}
