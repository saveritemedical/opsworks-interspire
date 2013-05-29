if (node[:interspire][:ec2_path] && ! FileTest.directory?(node[:interspire][:ec2_path]))
  Chef::Log.info("Setting up the MySQL bind-mount to EBS")

  execute "Copy Interspire data to EBS for first init" do
    command "mkdir -p #{node[:interspire][:path]}"
    not_if do
      FileTest.directory?(node[:interspire][:ec2_path])
    end
  end

  directory node[:interspire][:ec2_path] do
    owner "apache"
    group "nginx"
  end

  execute "ensure MySQL data owned by MySQL user" do
    command "chown -R apache:nginx #{node[:interspire][:path]}"
    action :run
  end

else
  Chef::Log.info("Skipping Interspire EBS setup - using what is already on the EBS volume")
end

bash "adding bind mount for cache, config to #{node[:interspire][:opsworks_autofs_map_file]}" do
	user 'root'
	code <<-EOC
		echo '#{node[:interspire][:path]} -fstype=none,bind,rw :#{node[:interspire][:ec2_path]}' >> #{node[:interspire][:opsworks_autofs_map_file]}
		service autofs restart
		ln -s #{node[:interspire][:path]}/config #{node[:interspire][:shared_path]}/conf
		ln -s #{node[:interspire][:path]}/cache #{node[:interspire][:shared_path]}/cache
	EOC
	not_if { ::File.read("#{node[:interspire][:opsworks_autofs_map_file]}").include?("#{node[:interspire][:path]}") }
end
