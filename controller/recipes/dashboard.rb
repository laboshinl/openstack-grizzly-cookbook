%w[openstack-dashboard memcached node-less].each do |pkg|
	package pkg do
		action :install
	end
end

bash "remove ubuntu dashboard theme" do
	code <<-CODE
		rm /etc/openstack-dashboard/ubuntu_theme.py
	CODE
end

%w[apache2 memcached].each do |srv| 
	service srv do
		action :restart
	end
end
