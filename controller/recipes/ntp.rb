package "ntp" do
	action :install
end

template "/etc/ntp.conf" do
	source "ntp/ntp.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

service "ntp" do
	action :restart
end
