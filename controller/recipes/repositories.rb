execute "apt-get update" do
	action :nothing
end

# OpenStack 'Grizzly' repository key
#bash "add Grizzly key" do
	#code <<-CODE
	#gpg --keyserver keyserver.ubuntu.com --recv EC4926EA 
	#gpg --export --armor EC4926EA | apt-key add -
	#CODE
#end

bash "add Grizzly key" do
	code <<-CODE
	gpg --keyserver keyserver.ubuntu.com --recv 3B6F61A6 
	gpg --export --armor 3B6F61A6 | apt-key add -
	CODE
end

# Ceph repository key
bash "add Ceph key" do
	code <<-CODE
	gpg --keyserver keyserver.ubuntu.com --recv 17ED316D
	gpg --export --armor 17ED316D | apt-key add -
	CODE
end 

# Updated list of Ubuntu repositories	 
template "/etc/apt/sources.list" do
	owner "root"
	mode "0644"
	source "repositories/sources.list.erb"
	notifies :run, resources("execute[apt-get update]"), :immediately
end
