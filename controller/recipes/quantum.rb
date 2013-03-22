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

bash "create integration bridge" do
	not_if("ovs-vsctl list-br | grep br-ex")
	code <<-CODE
	ovs-vsctl add-br br-ex
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

%w[quantum-dhcp-agent quantum-plugin-openvswitch-agent quantum-l3-agent quantum-server quantum-metadata-agent].each do |srv|
	service srv do
		action :restart
	end
end

