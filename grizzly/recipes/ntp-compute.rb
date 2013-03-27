package "ntp" do
	action :install
end

service "ntp" do
	action :nothing
	supports :status => true, :restart => true, :start => true  
end

template "/etc/ntp.conf" do
	not_if ("grep 127.127.1.0 /etc/ntp.conf")
		source "ntp/ntp-compute.conf.erb"
		owner "root"
		group "root"
		mode "0644"
		notifies :restart, resources(:service => "ntp"), :immediately
end
