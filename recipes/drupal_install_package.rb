#
# Cookbook Name:: drupal
# Recipe:: drupal_install_package
#
# Copyright (c) 2014, The University of Queensland
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# * Neither the name of the The University of Queensland nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY OF QUEENSLAND BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

package "drupal#{version}" do
  action :install
end

bash 'install drupal.conf' do
  code "cp /etc/drupal/#{version}/apache2.conf /etc/apache2/mods-enabled/drupal.conf"
  notifies :restart, "service[apache2]", :delayed
end

sites = "/usr/share/drupal#{version}/sites"

template "#{sites}/settings.php" do 
  source 'settings.php.erb'
end

template "#{sites}/baseurl.php" do 
  source 'baseurl.php.erb'
end

template "#{sites}/default/dbconfig.php" do 
  source 'dbconfig.php.erb'
  notifies :run, "ruby_block[announce]", :delayed
end

# TODO (?) - create a cronkey.php file and a crontab entry with that key ...
#            as per https://api.drupal.org/api/drupal/INSTALL.txt/7

ruby_block 'announce' do
  block do
    puts '*****************************************************************'
    puts '*****************************************************************'
    puts 'You need to complete the Drupal installation process as follows: '
    puts " 1) Use a web browser to visit #{install_url}"
    puts "    and go through the forms."
    puts " 2) Secure the settings file by running the following:"
    puts "    $ sudo chmod 644 #{sites}/default/settings.php"
    puts "    $ sudo chmod 644 #{sites}/settings.php"
    puts '*****************************************************************'
    puts '*****************************************************************'
  end
  action :run
end
