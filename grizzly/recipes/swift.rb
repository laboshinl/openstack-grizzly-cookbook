bash "create database for swift" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep swift")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE swift;"
		CODE
end

%w[swift swift-proxy python-pastedeploy rsync].each do |pkg|
	package pkg do
		action :install
	end
end

directory "/etc/swift/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
end

directory "/run/swift/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
end	

template "/etc/swift/proxy-server.conf" do
	source "swift/proxy-server.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
end

template "/etc/swift/swift.conf" do
	source "swift/swift.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
end

template "/etc/rsyncd.conf" do
	source "swift/rsyncd.conf.erb"
	owner "root"
	group "root"
	mode "0755"
end

bash "create_builders" do
	code <<-EOF
		cd /etc/swift
		swift-ring-builder object.builder create 18 3 1
		swift-ring-builder container.builder create 18 3 1
		swift-ring-builder account.builder create 18 3 1
	EOF
end

%x[sed -e "s/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g" -i /etc/default/rsync]

service "rsync" do
	action :restart
end
 
bash "swift" do
	code <<-EOF
	chown swift:swift /etc/swift -R
	EOF
end
