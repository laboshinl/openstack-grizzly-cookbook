bash "create database for swift" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep swift")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE swift;"
		CODE
end

%w[swift swift-proxy swift-account swift-container swift-object python-pastedeploy rsync].each do |pkg|
	package pkg do
		action :install
	end
end

directory "/run/swift/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
end
	

%w[node1 node2 node3 node4].each do |dir|
   directory "/srv/#{dir}/device/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
   end
end

%w[account-server container-server object-server].each do |dir|
   directory "/etc/swift/#{dir}/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
   end
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

%w{1 2 3 4}.each do |num|
template "/etc/swift/container-server/#{num}.conf" do
	source "swift/container.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
	variables :num => "#{num}" 
	end

template "/etc/swift/object-server/#{num}.conf" do
	source "swift/object.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
	variables ({
   		:num => "#{num}" 
  	})
	end
template "/etc/swift/account-server/#{num}.conf" do
	source "swift/account.conf.erb"
	owner "swift"
	group "swift"
	mode "0755"
	variables ({
   		:num => "#{num}" 
  	})
	end

bash "create" do
	ignore_failure true
	code <<-CODE
	cd /etc/swift/
	swift-ring-builder object.builder add z"#{num}"-127.0.0.1:60"#{num}"0/device 1
	swift-ring-builder container.builder add z"#{num}"-127.0.0.1:60"#{num}"1/device 1
	swift-ring-builder account.builder add z"#{num}"-127.0.0.1:60"#{num}"2/device 1
	CODE
	end
end

%x[sed -e "s/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g" -i /etc/default/rsync]

service "rsync" do
	action :restart
end
 
bash "swift" do
	code <<-EOF
	chown swift:swift /etc/swift -R
	cd /etc/swift
	swift-ring-builder object.builder rebalance
	swift-ring-builder container.builder rebalance
	swift-ring-builder account.builder rebalance
	swift-init main start
	EOF
end
