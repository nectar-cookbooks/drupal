version = node['drupal']['version'] || '7'
install_dir = node['apache']['docroot_dir'] 

case version
when 'latest'
  version = '7' 
when '6', '7' then
  # OK
else
  raise "Don't know how to install Drupal version '#{drupal}' from packages"
end

@drupal_sites = "/usr/share/drupal#{version}/sites"

include_recipe "drush::pear"

bash 'install drupal.conf' do
  code "cp /etc/drupal/#{version}/apache2.conf /etc/apache2/mods-enabled/drupal.conf"
  notifies :restart, "service[apache2]", :delayed
end

include_recipe "drupal::preconfigure"

drush_execute "site-install" 
