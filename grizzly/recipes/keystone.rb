bash "create database for keystone" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep keystone")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE keystone;"
		CODE
end

package "keystone" do
	action :install
end

template "/etc/keystone/keystone.conf" do
	source "keystone/keystone.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/keystone/default_catalog.templates" do
	source "keystone/default_catalog.templates.erb"
	owner "root"
	group "root"
	mode "0644"
end

service "keystone" do
	action :restart
end

bash "synchronise keystone database" do
	code <<-CODE
		keystone-manage db_sync
	CODE
end

bash "create default keystone users" do
	not_if("mysql -uroot -p#{node[:admin][:password]} keystone -e 'SELECT * FROM user' | grep admin")
		code <<-CODE
  			export SERVICE_TOKEN=#{node[:admin][:password]} 
  			export SERVICE_ENDPOINT="http://127.0.0.1:35357/v2.0"
  			ADMIN_TENANT=$(keystone tenant-create --name=admin | awk '/ id / { print $4 }')
			TEST_TENANT=$(keystone tenant-create --name=test | awk '/ id / { print $4 }')
  			ADMIN_USER=$(keystone user-create --name=admin --pass=#{node[:admin][:password]} --email=#{node[:admin][:email]} | awk '/ id / { print $4 }')
			TESTER_USER=$(keystone user-create --name=tester --pass=#{node[:admin][:password]} --email=#{node[:admin][:email]} | awk '/ id / { print $4 }')
  			ADMIN_ROLE=$(keystone role-create --name=admin | awk '/ id / { print $4 }')
			MEMBER_ROLE=$(keystone role-create --name=Member | awk '/ id / { print $4 }')
  			keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT
			keystone user-role-add --user-id $TESTER_USER --role-id $MEMBER_ROLE --tenant-id $TEST_TENANT		
		CODE
end

template "/root/adminrc.sh" do
	source "keystone/adminrc.sh.erb"
	owner "root"
	group "root"
	mode "0700"
end
