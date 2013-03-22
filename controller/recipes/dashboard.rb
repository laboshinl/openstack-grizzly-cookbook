%w[openstack-dashboard memcached node-less].each do |pkg|
	package pkg do
		action :install
	end
end
