%w[openvswitch-switch quantum-plugin-openvswitch-agent].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/quantum/quantum.conf" do
	owner "root"
	group "quantum"
	mode "0644"
	source "quantum/quantum.conf.erb"
end

template "/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini" do
	owner "root"
	group "quantum"
	mode "0644"
	source "quantum/ovs_quantum_plugin.ini.erb"
end

bash "create integration bridge" do
	not_if("ovs-vsctl list-br | grep br-int")
	code <<-CODE
	ovs-vsctl add-br br-int
	CODE
end

%w[openvswitch-switch quantum-plugin-openvswitch-agent].each do |srv|
	service srv do
		action :restart
	end
end
