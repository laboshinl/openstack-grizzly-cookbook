bash "create database for swift" do
	not_if("mysql -uroot -p#{node[:admin][:password]} -e 'SHOW DATABASES' | grep swift")
		code <<-CODE
			mysql -uroot -p#{node[:admin][:password]} -e "CREATE DATABASE swift;"
		CODE
end
