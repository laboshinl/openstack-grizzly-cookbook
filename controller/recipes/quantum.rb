package "quantum-server python-cliff quantum-l3-agent quantum-dhcp-agent python-pyparsing" do
	action :install
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
	source "quantum/l3_agetn.ini.erb"
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

bash "restart all quantum services" do
	code <<-CODE
	cd /etc/init.d/; for i in $( ls quantum* ); do sudo service $i restart; done
	CODE
end
