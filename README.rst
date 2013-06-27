Feel free to ask any questions and open issues

Attributes
==========

See the `attributes/default.rb` for default values. 

Usage
=====

Controller node.json: ::

	{
		"admin": {
			  "password": "superSecret",
			  "email": "admin@cloud.com"
			},
		"controller":{
			  "private_ip": "10.0.0.1",
			  "public_ip": "192.168.0.100"
			},
		"run_list":[
			"recipe[grizzly::set_attributes]",
			"recipe[grizzly::ip_forwarding]",
			"recipe[grizzly::users]",
			"recipe[grizzly::ntp]",
			"recipe[grizzly::repositories]",
			"recipe[grizzly::rabbitmq-server]",
			"recipe[grizzly::mysql-server]",
			"recipe[grizzly::keystone]",
			"recipe[grizzly::swift]",
			"recipe[grizzly::ceph]",
			"recipe[grizzly::glance]",
			"recipe[grizzly::cinder]",
			"recipe[grizzly::openvswitch]",
			"recipe[grizzly::quantum]",
			"recipe[grizzly::nova]",
			"recipe[grizzly::dashboard]"
			]
	}
	
Compute node.json: ::

	{
		"admin": {
			  "password": "superSecret",
			  "email": "admin@cloud.com"
			},
		"controller":{
			  "private_ip": "10.0.0.1",
			  "public_ip": "192.168.0.100"
			},
		"run_list":[
			"recipe[grizzly::set_attributes]",
			"recipe[grizzly::ip_forwarding]",
			"recipe[grizzly::users]",
			"recipe[grizzly::ntp-compute]",
			"recipe[grizzly::repositories]",
			"recipe[grizzly::openvswitch]",
			"recipe[grizzly::libvirt]",
			"recipe[grizzly::nova-compute]",
			"recipe[grizzly::swift-compute]"
			]
	}

All in one node.json: ::

	{
		"admin": {
			  "password": "superSecret",
			  "email": "admin@cloud.com"
			},
		"controller":{
			  "private_ip": "10.0.0.1",
			  "public_ip": "192.168.0.100"
			},
		"run_list":[
			"recipe[grizzly::set_attributes]",
			"recipe[grizzly::ip_forwarding]",
			"recipe[grizzly::users]",
			"recipe[grizzly::ntp]",
			"recipe[grizzly::repositories]",
			"recipe[grizzly::rabbitmq-server]",
			"recipe[grizzly::mysql-server]",
			"recipe[grizzly::keystone]",
			"recipe[grizzly::swift]",
			"recipe[grizzly::ceph]",
			"recipe[grizzly::glance]",
			"recipe[grizzly::cinder]",
			"recipe[grizzly::openvswitch]",
			"recipe[grizzly::quantum]",
			"recipe[grizzly::nova]",
			"recipe[grizzly::libvirt]",
			"recipe[grizzly::nova-compute]",
			"recipe[grizzly::swift-compute]",
			"recipe[grizzly::dashboard]"
			]
	}
