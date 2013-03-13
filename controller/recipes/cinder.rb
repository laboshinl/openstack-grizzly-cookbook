bash "create database for cinder" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep cinder")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE cinder;"
		CODE
end

%w[cinder-api cinder-scheduler cinder-volume iscsitarget open-iscsi iscsitarget-dkms python-cinderclient ceph-common].each do |pkg|
	package pkg do
		action :install
	end
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

bash "add ceph setting" do
    not_if("cat /etc/init/cinder-volume.conf | grep 'id volumes' | grep CEPH_ARGS")
	code <<-CODE
	sed -i '1ienv CEPH_ARGS="--id volumes"' /etc/init/cinder-volume.conf
	CODE
end

%w[iscsitarget open-iscsi cinder-api cinder-scheduler cinder-volume].each do |srv|
	service srv do
		action :restart
	end
end
