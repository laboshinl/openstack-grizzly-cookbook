bash "create database for nova" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep nova")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE nova;"
		CODE
end

package "nova-objectstore nova-consoleauth nova-xvpvncproxy nova-api nova-cert nova-scheduler " do
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

bash "synchronise nova database" do
	code <<-CODE
		nova-manage db sync
	CODE
end 

["nova-cert", "nova-api", "nova-scheduler", "nova-consoleauth", "nova-objectstore"].each do |pkg|
	service pkg do
		action :restart
	end
end
