#!/bin/bash

# Import tests
. ./test_defs.sh

# Cleanup anything previous
vagrant destroy -f

# Use Single node environment for baseline
rm -f Vagrantfile
ln -s Vagrantfile.single_node Vagrantfile
vagrant up --provider=aws

vagrant ssh -c "$CLEANUP"

vagrant ssh -c "$PREPARE_INNODB"
echo "Baseline Innodb Test"
vagrant ssh -c "$RUN_TEST" -- > results/baseline_innodb.txt
vagrant ssh -c "$CLEANUP"

vagrant ssh -c "$PREPARE_MYISAM"
echo "Baseline MyISAM Test"
vagrant ssh -c "$RUN_TEST" -- > results/baseline_myisam.txt
vagrant ssh -c "$CLEANUP"


# vagrant destroy -f
