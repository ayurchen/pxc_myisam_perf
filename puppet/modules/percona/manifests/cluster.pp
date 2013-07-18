class percona::cluster {
	case $operatingsystem {
		centos: {
			package {
				"Percona-XtraDB-Cluster-server.$hardwaremodel":
					require => [ Yumrepo['percona'], Package['MySQL-shared-compat'] ],
					alias => "MySQL-server",
					ensure => "installed";
				"Percona-XtraDB-Cluster-client.$hardwaremodel":
					require => [ Yumrepo['percona']],
					alias => "MySQL-client",
					ensure => "installed";
				"rsync":
					ensure => "present";  
				"Percona-Server-shared-compat":
					require => [ Yumrepo['percona'], Package['MySQL-client'] ],
					alias => "MySQL-shared-compat",
					ensure => "installed";
				# "mysql-libs":
				# 	ensure => "absent";
			}
		}
		ubuntu: {
			package {
				"percona-xtradb-cluster-server-5.5":
					alias => "MySQL-server";
				"percona-xtradb-cluster-client-5.5":
					alias => "MySQL-client";
			}
		}
	}	

	service {
		"mysql":
			enable  => true,
			ensure  => 'running',
			require => Package['MySQL-server'],
	}
	
	exec { 'xtrabackup_sst_grant_node1':
    command => "/usr/bin/mysql -u root -e \"GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'sst'@'localhost' IDENTIFIED BY 'secret'\"",  
		path => "/usr/bin:/usr/sbin:/bin:/sbin",
    unless => "/usr/bin/mysql -u root -e\"SELECT User from mysql.user WHERE User='sst';\" | /bin/grep -q sst",
		require => Service['mysql'];
	}
	
	
}