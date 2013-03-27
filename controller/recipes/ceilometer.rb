bash "create database for ceilometer" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep ceilometer")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE ceilometer;"
		CODE
end

%w[ceilometer-agent-central ceilometer-agent-compute ceilometer-api ceilometer-collector ceilometer-common python-ceilometer mongodb].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/ceilometer/ceilometer.conf" do
	source "ceilometer/ceilometer.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

bash "synchronise ceilometer database" do
	code <<-CODE
		ceilometer-dbsync
	CODE
end

%w[ceilometer-agent-central ceilometer-agent-compute ceilometer-api ceilometer-collector].each do |srv|
	service srv do
		action :restart
	end
end

Chef::Log.info "Ceilometer install complete =)"
