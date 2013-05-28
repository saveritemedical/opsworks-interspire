Chef::Log.info("Skipping Interspire EBS setup - using what is already on the EBS volume")

bash "adding bind mount for cache, config to #{node[:interspire][:opsworks_autofs_map_file]}" do
	user 'root'
	code <<-EOC
		echo "/srv/www/administration_panel/shared/interspire -fstype=none,bind,rw :/vol/interspire" >> #{node[:interspire][:opsworks_autofs_map_file]}
		service autofs restart
	EOC
	not_if { ::File.read("#{node[:interspire][:opsworks_autofs_map_file]}").include?("/srv/www/administration_panel/shared/interspire") }
end
