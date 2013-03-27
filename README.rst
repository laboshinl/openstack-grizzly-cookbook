All in one node.json: ::

	{
		"admin": {
			  "password": "cl0udAdmin",
			  "email": "laboshinl@neva.ru"
			},
		"controller":{
			  "private_ip": "10.10.10.12",
			  "public_ip": "195.208.117.182"
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
			"recipe[grizzly::dashboard]"
			]
	}
