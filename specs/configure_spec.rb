require 'minitest/spec'

describe_recipe 'php::configure' do
  include MiniTest::Chef::Resources
  include MiniTest::Chef::Assertions

  it 'creates the php file for data exchange' do
    if deploy[:application_type] = 'php'
      file("#{deploy[:deploy_to]}/current/db-config.php").must_exist.with(:mode, '0660').and(:owner, deploy[:user]).and(:group, deploy[:group])
    end
  end
end
