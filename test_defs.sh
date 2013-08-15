
# Test commands
PREPARE_MYISAM="sysbench --test=sysbench_tests/db/common.lua --mysql-table-engine=MyISAM --mysql-user=root --mysql-db=test --oltp-table-size=1000000 prepare"
PREPARE_INNODB="sysbench --test=sysbench_tests/db/common.lua --mysql-table-engine=InnoDB --mysql-user=root --mysql-db=test --oltp-table-size=1000000 prepare"

RUN_TEST="sysbench --test=sysbench_tests/db/update_index.lua --mysql-user=root --mysql-db=test --oltp-table-size=1000000 --max-requests=0 --max-time=600 --num-threads=8 --report-interval=1 run"

CLEANUP="sysbench --test=sysbench_tests/db/common.lua --mysql-user=root --mysql-db=test cleanup"