["swift-account", "swift-container", "swift-object", "rsync"].each do |pkg|
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
	

%w{node1 node2 node3 node4}.each do |dir|
   directory "/srv/#{dir}/device/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
   end
end

%w{account-server container-server object-server}.each do |dir|
   directory "/etc/swift/#{dir}/" do
	mode "0775"
	owner "swift"
	group "swift"
	action :create
	recursive true
   end
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
	
bash "create rings" do
	not_if('ifconfig | grep {node[:controller][:private_ip]}')
	ignore_failure true
	code <<-CODE
	ssh -oStrictHostKeyChecking=no -oCheckHostIP=no #{node[:controller][:private_ip]} 'cd /etc/swift/; swift-ring-builder object.builder add z"#{num}"-#{require 'socket'; UDPSocket.open {|s| s.connect(node[:controller][:private_ip], 1); s.addr.last} }:60"#{num}"0/device 1'
	ssh #{node[:controller][:private_ip]} 'cd /etc/swift/; swift-ring-builder container.builder add z"#{num}"-#{require 'socket'; UDPSocket.open {|s| s.connect(node[:controller][:private_ip], 1); s.addr.last} }:60"#{num}"1/device 1'
	ssh #{node[:controller][:private_ip]} 'cd /etc/swift/; swift-ring-builder account.builder add z"#{num}"-#{ require 'socket'; UDPSocket.open {|s| s.connect(node[:controller][:private_ip], 1); s.addr.last} }:60"#{num}"2/device 1'
	ssh #{node[:controller][:private_ip]} 'cd /etc/swift/; swift-ring-builder object.builder rebalance; swift-ring-builder container.builder rebalance; swift-ring-builder account.builder rebalance'
	CODE
	end

bash "create rings" do
	only_if('ifconfig | grep {node[:controller][:private_ip]}')
	ignore_failure true
	code <<-CODE
	cd /etc/swift/
	swift-ring-builder object.builder add z"#{num}"-#{node[:controller][:private_ip]}:60"#{num}"0/device 1
	swift-ring-builder container.builder add z"#{num}"-#{node[:controller][:private_ip]}:60"#{num}"1/device 1
	swift-ring-builder account.builder add z"#{num}"-#{node[:controller][:private_ip]}:60"#{num}"2/device 1
	swift-init proxy-server start
	swift-ring-builder object.builder rebalance
	swift-ring-builder container.builder rebalance
	swift-ring-builder account.builder rebalance
	CODE
	end
end

bash "get rings" do
	not_if('ifconfig | grep {node[:controller][:private_ip]}')
	code <<-CODE
	scp #{node[:controller][:private_ip]}:/etc/swift/container.ring.gz /etc/swift/container.ring.gz
	scp #{node[:controller][:private_ip]}:/etc/swift/account.ring.gz /etc/swift/account.ring.gz
	scp #{node[:controller][:private_ip]}:/etc/swift/object.ring.gz /etc/swift/object.ring.gz
	CODE
end

%x[sed -e "s/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g" -i /etc/default/rsync]

service "rsync" do
	action :restart
end
 
bash "swift" do
	code <<-EOF
	chown swift:swift /etc/swift -R
	swift-init main start
	EOF
end
