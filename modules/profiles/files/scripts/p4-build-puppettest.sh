#!/bin/bash

# This script will create a client and perform a p4 sync of the head

export P4CLIENT=build_puppettest

if ! [ $(p4 clients -u build | grep $P4CLIENT) ]; then

p4 client -i << EOF
Client: build_puppettest
Owner: build
Host: puppet.vagrant.local
Description: Client used for automatic puppet testing via vagrant.
Root: /home/build/puppet_testing/
Options: noallwrite noclobber nocompress unlocked nomodtime rmdir
SubmitOptions:  submitunchanged
LineEnd:        local
View:
  //depot/quicksync/puppet/manifests/... //build_puppettest/manifests/...
  //depot/quicksync/puppet/modules/... //build_puppettest/modules/...
  //depot/quicksync/puppet/environments/... //build_puppettest/environments/...
  //depot/quicksync/puppet/hiera/... //build_puppettest/hiera/...
  -//depot/quicksync/puppet/modules/....rpm //build_puppettest/modules/....rpm
  -//depot/quicksync/puppet/environments/....rpm //build_puppettest/environments/....rpm
  -//depot/quicksync/puppet/modules/....tar.gz //build_puppettest/modules/....tar.gz
  -//depot/quicksync/puppet/environments/....tar.gz //build_puppettest/environments/....tar.gz
EOF

fi

