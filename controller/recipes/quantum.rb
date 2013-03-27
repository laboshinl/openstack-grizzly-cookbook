bash "create database for quantum" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep quantum")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE quantum;"
		CODE
end

%w[quantum-server python-cliff quantum-l3-agent quantum-dhcp-agent python-pyparsing].each do |pkg|
	package pkg do 
		action :install
	end
end

bash "create external bridge" do
	not_if("ovs-vsctl list-br | grep br-ex")
	code <<-CODE
	ovs-vsctl add-br br-ex
	CODE
end

bash "configure external bridge" do
	not_if("cat /etc/network/interfaces | grep br-ex")
		code <<-CODE
		sed -i 's/#{node[:controller][:public_iface]}/br-ex/g' /etc/network/interfaces
		(echo ; echo auto #{node[:controller][:public_iface]}; echo iface #{node[:controller][:public_iface]} inet manual; echo '	up ifconfig $IFACE 0.0.0.0 up'; echo '	up ip link set $IFACE promisc on'; echo '	down ip link set $IFACE promisc off'; echo '	down ifconfig $IFACE down') >> /etc/network/interfaces    
		ifconfig #{node[:controller][:public_iface]} down && /etc/init.d/networking restart && ovs-vsctl add-port br-ex #{node[:controller][:public_iface]}
		CODE
end

template "/etc/quantum/l3_agent.ini" do
	owner "root"
	group "quantum"
	mode "0644"
	source "quantum/l3_agent.ini.erb"
end

template "/etc/quantum/dhcp_agent.ini" do
	owner "root"
	group "quantum"
	mode "0644"
	source "quantum/dhcp_agent.ini.erb"
end

template "/etc/quantum/metadata_agent.ini" do
	owner "root"
	group "quantum"
	mode "0644"
	source "quantum/metadata_agent.ini.erb"
end

template "/root/quantum.sh" do
	owner "root"
	group "root"
	mode "0644"
	source "quantum/quantum.sh"
end

%w[quantum-dhcp-agent quantum-plugin-openvswitch-agent quantum-l3-agent quantum-server quantum-metadata-agent].each do |srv|
	service srv do
		action :restart
	end
end

bash "create external network" do
	code <<-CODE
		source /root/adminrc.sh
		exist=$(quantum net-list | grep -o "ext_net")
		if [ -n "$exist" ] ; then
			echo "Already created, doing nothing"
		else
			ADMIN=$(keystone tenant-list | awk '/admin/{print $2}')
			quantum net-create --tenant-id $ADMIN ext_net --shared --router:external=True
		fi
	CODE
end

Chef::Log.info "Quantum installed =)"
