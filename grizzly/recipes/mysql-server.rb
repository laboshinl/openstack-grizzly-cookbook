directory "/var/cache/local/preseeding/" do
	owner "root"
	group "root"
	mode 0755
	recursive true
end

execute "preseed mysql" do
	command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
	action :nothing
end

template "/var/cache/local/preseeding/mysql-server.seed" do
	source "mysql-server/mysql-server.seed.erb"
	owner "root"
	group "root"
	mode "0600"
	notifies :run, resources(:execute => "preseed mysql"), :immediately
end

package "mysql-server-5.5 python-mysqldb" do
	action :install
end

service "mysql" do
	action :nothing
	supports :status => true, :restart => true, :start => true  
end

template "/etc/mysql/my.cnf" do
	source "mysql-server/my.cnf.erb"
	owner "root"
	group "root"
	mode "0600"
	notifies :restart, resources(:service => "mysql"), :immediately
end

bash "allow databases access " do
	code <<-CODE
		mysql -uroot -p#{node[:admin][:password]} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '#{node[:admin][:password]}';"
	CODE
end
