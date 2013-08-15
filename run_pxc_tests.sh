#!/bin/bash

# Import tests
. ./test_defs.sh

# Cleanup anything previous
# vagrant destroy -f

# Use Single node environment for baseline
rm -f Vagrantfile
ln -s Vagrantfile.pxc Vagrantfile
vagrant up --provider=aws
sleep 30
echo "Bootstrapping"
./bootstrap.sh

# Master/Slave cluster tests
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_INNODB"
echo "Master/Slave Innodb Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/ms_innodb.txt
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_MYISAM"
echo "Master/Slave MyISAM Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/ms_myisam.txt
vagrant ssh node1 -c "$CLEANUP"


# vagrant destroy -f
