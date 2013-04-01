package "ceph" do
	action :install
end

template "/etc/ceph/ceph.conf" do
	owner "root"
	mode "0644"
	source "ceph/ceph.conf.erb"
end

bash "create directories" do
	code <<-CODE
	mkdir -p /var/lib/ceph/osd/ceph-0
	mkdir -p /var/lib/ceph/mon/ceph-a
	mkdir -p /var/lib/ceph/mds/ceph-a
	CODE
end

bash "activate ceph" do
	not_if("ls -A /var/lib/ceph/osd/ceph-0")
		code <<-CODE
		mkcephfs -a -c /etc/ceph/ceph.conf
		service ceph -a restart
		ceph osd pool create volumes 128
		CODE
end

