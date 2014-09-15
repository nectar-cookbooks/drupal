#
# Cookbook Name:: drupal
# Recipe:: drupal_install_drush
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

drupal = node['drupal']
version = drupal['version'] || '7'
install_dir = node['apache']['docroot_dir'] 

case version
when 'latest', '7'
  dl_tag = 'drupal-7' 
when '6' then
  dl_tag = 'drupal-6'
else
  raise "I don't understand Drupal version #{version}"
end

drupal_installation = "/usr/share/drupal#{version}"
$drupal_sites = "/usr/share/drupal#{version}/sites"

package "drush"

bash "download drupal" do
  code "drush dl #{dl_tag} --destination #{drupal_installation}"
end

db = drupal['databases']['default/default']
db_url = "mysql://#{db['username']}:#{db['password']}@" +
  "#{db['host']}/#{db['database']}"
opts = "--db-url=#{db_url} --account-name=admin --account-pass=admin"
if db['prefix'] && db['prefix'] != '' then
  opts += " --db-prefix=#{db['prefix']}"
end

bash "install drupal" do
  cwd drupal_installation
  code "drush si standard #{opts}" 
end

return

bash 'install drupal.conf' do
  code "cp /etc/drupal/#{version}/apache2.conf /etc/apache2/mods-enabled/drupal.conf"
  notifies :restart, "service[apache2]", :delayed
end
