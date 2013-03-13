package "ceph" do
	action :install
end

bash "lvcreate" do
	not_if("lvdisplay | grep ceph")
	code <<-CREATE
		unit=$(vgdisplay #{node[:volume_group][:name]} | grep Free |  awk '{print $8}')
		size=$(vgdisplay #{node[:volume_group][:name]} | grep Free |  awk '{print $7}')
		ceph=$(echo "$size*0.5" | bc)
		lvcreate -n ceph -L 0$ceph$unit #{node[:volume_group][:name]}
	CREATE
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

bash "lvcreate" do
	code <<-CODE
	mkcephfs -a -c /etc/ceph/ceph.conf
	service ceph -a restart
	ceph osd pool create volumes 128
	ceph osd pool create images 128
	CODE
end

