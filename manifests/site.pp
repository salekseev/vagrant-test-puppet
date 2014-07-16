node 'puppet.vagrant.local' {
  package { 'p4':
    ensure   => 'installed',
    source   => 'http://cobbler200.athenahealth.com/LocalRepo/athena-6/RPMS/p4-2014.1.807760-1.x86_64.rpm',
    provider => 'rpm'
  }
}
