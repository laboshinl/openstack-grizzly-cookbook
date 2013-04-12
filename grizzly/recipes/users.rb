user "nova" do
	uid 997
	action :create
end

group "nova" do
	gid 998
	action :create
	members "nova"
end

group "libvirtd" do
	gid 999
	action :create
	members "nova"
end


