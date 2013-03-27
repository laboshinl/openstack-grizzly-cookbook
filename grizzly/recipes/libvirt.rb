%w[libvirt-bin pm-utils].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/libvirt/qemu.conf" do
	source "libvirt/qemu.conf"
	owner "nova"
	group "nova"
	mode "0644"
end

template "/etc/libvirt/libvirtd.conf" do
	source "libvirt/libvirtd.conf"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/init/libvirt-bin.conf" do
	source "libvirt/libvirt-bin.conf"
	owner "root"
	group "root"
	mode "0644"
end

template "/etc/default/libvirt-bin" do
	source "libvirt/libvirt-bin"
	owner "root"
	group "root"
	mode "0644"
end

service "libvirt-bin" do
	action :restart
end
