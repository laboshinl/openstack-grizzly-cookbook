bash "create database for cinder" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep cinder")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE cinder;"
		CODE
end

package "cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms python-cinderclient" do
		action :install
end

bash "enable iscsi" do
	code <<-CODE
	sed -i 's/false/true/g' /etc/default/iscsitarget
	CODE
end

template "/etc/cinder/cinder.conf" do
	source "cinder/cinder.conf.erb"
	owner "cinder"
	group "cinder"
	mode "0644"
end

template "/etc/cinder/api-paste.ini" do
	source "cinder/api-paste.ini.erb"
	owner "cinder"
	group "cinder"
	mode "0644"
end

bash "syncronise cinder database" do
	code <<-CODE
	cinder-manage db sync
	CODE
end

%w[iscsitarget open-iscsi cinder-api cinder-scheduler cinder-volume].each do |srv|
	service srv do
		action :restart
	end
end
