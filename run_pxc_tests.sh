#!/bin/bash

# Import tests
. ./test_defs.sh
# 
# Cleanup anything previous
vagrant destroy -f

# # Use Single node environment for baseline
rm -f Vagrantfile
ln -s Vagrantfile.pxc Vagrantfile
vagrant up --provider=aws
sleep 30


# Baseline tests (remove wsrep settings here manually)
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_INNODB"
echo "PXC 1 node Innodb Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/baseline_innodb.txt
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_MYISAM"
echo "PXC 1 node MyISAM Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/baseline_myisam.txt
vagrant ssh node1 -c "$CLEANUP"



# Single node tests (put wsrep settings back and restart mysql)
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_INNODB"
echo "PXC 1 node Innodb Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/pxc_1_innodb.txt
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_MYISAM"
echo "PXC 1 node MyISAM Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/pxc_1_myisam.txt
vagrant ssh node1 -c "$CLEANUP"


# Startup the other nodes 
echo "Bootstrapping"
./bootstrap.sh


#Master/Slave cluster tests
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_INNODB"
echo "Master/Slave Innodb Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/ms_innodb.txt
vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_MYISAM"
echo "Master/Slave MyISAM Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/ms_myisam.txt
vagrant ssh node1 -c "$CLEANUP"


# 
# # 3 Node Writer tests
# 
vagrant ssh node1 -c "$PREPARE_INNODB"
echo "Multi Writer Innodb Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/multi_innodb_1.txt &
vagrant ssh node2 -c "$RUN_TEST" -- > results/multi_innodb_2.txt &
vagrant ssh node3 -c "$RUN_TEST" -- > results/multi_innodb_3.txt

sleep 10;

vagrant ssh node1 -c "$CLEANUP"

vagrant ssh node1 -c "$PREPARE_MYISAM"
echo "Multi Writer MyISAM Test"
vagrant ssh node1 -c "$RUN_TEST" -- > results/multi_myisam_1.txt &
vagrant ssh node2 -c "$RUN_TEST" -- > results/multi_myisam_2.txt &
vagrant ssh node3 -c "$RUN_TEST" -- > results/multi_myisam_3.txt
sleep 10;

vagrant ssh node1 -c "$CLEANUP"
# 
# # vagrant destroy -f
