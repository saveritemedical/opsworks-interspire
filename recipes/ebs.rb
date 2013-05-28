Chef::Log.info("Skipping Interspire EBS setup - using what is already on the EBS volume")

bash "adding bind mount for cache, config to #{node[:interspire][:opsworks_autofs_map_file]}" do
	user 'root'
	code <<-EOC
		echo '/srv/www/administration_panel/shared/interspire -fstype=none,bind,rw :/vol/interspire' >> /etc/auto.opsworks
		service autofs restart
	EOC
	not_if { ::File.read("/etc/auto.opsworks").include?("/srv/www/administration_panel/shared/interspire") }
end
