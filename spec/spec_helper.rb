require File.dirname(__FILE__) + '/../lib/svn'

# use .config file in Workspace if it is present
if File.file?("#{ENV['WORKSPACE']}/.config.yaml")

  $config_file = YAML.load_file("#{ENV['WORKSPACE']}/.config.yaml")

else

  $config_file = YAML.load_file('.config.yaml')

end
