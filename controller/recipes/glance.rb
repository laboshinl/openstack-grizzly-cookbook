bash "create database for glance" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep glance")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE glance;"
		CODE
end

package "glance" do
	action :install
end

service "glance-registry" do
	action :nothing 
end

service "glance-api" do
	action :nothing
end

template "/etc/glance/glance-registry.conf" do
	source "glance/glance-registry.conf.erb"
	owner "glance"
	group "glance"
	mode "0644"
	notifies :restart, resources(:service => "glance-registry"), :immediately
end

template "/etc/glance/glance-api.conf" do
	source "glance/glance-api.conf.erb"
	owner "glance"
	group "glance"
	mode "0644"
	notifies :restart, resources(:service => "glance-api"), :immediately
end

bash "synchronise glance database" do
	code <<-CODE
		glance-manage db_sync
	CODE
end
