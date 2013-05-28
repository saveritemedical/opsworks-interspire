node[:deploy].each do |application, deploy|
	deploy = node[:deploy][application]
	Chef::Log.info("Skipping Interspire EBS setup - using what is already on the EBS volume")

	bash "adding bind mount for cache, config to #{node[:interspire][:opsworks_autofs_map_file]}" do
		user 'root'
		code <<-EOC
			echo "#{deploy[:deploy_to]}/shared/interspire -fstype=none,bind,rw :#{node[:interspire][:ec2_path]}" >> #{node[:interspire][:opsworks_autofs_map_file]}
			service autofs restart
		EOC
		not_if { ::File.read("#{node[:interspire][:opsworks_autofs_map_file]}").include?("#{deploy[:deploy_to]}/shared/interspire") }
	end
end
