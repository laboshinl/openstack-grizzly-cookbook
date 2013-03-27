%w[nova-compute-kvm pm-utils].each do |pkg|
	package pkg do
		action :install
	end
end

package "nova-api-metadata" do
	not_if ("ls /etc/init.d/ | grep nova-api")
		action :install
end

template "/etc/nova/api-paste.ini" do
	source "nova/api-paste.ini.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

template "/etc/nova/nova.conf" do
	source "nova/nova.conf.erb"
	owner "nova"
	group "nova"
	mode "0600"
end

service "nova-compute" do
	action "restart"
end

service "nova-api-metadata" do
	not_if ("ls /etc/init.d/ | grep nova-api")
		action :restart
end
