bash "create users" do
	not_if("id nova | grep libvirtd")
	code <<-START
	groupadd -g 999 nova
	groupadd -g 997 libvirtd
	useradd -u 998 -g 999 nova
	gpasswd -a nova libvirtd
	START
end
