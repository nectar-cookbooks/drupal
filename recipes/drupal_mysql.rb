#
# Cookbook Name:: drupal
# Recipe:: drupal_mysql
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

include_recipe "lamp::database"

databases = node['drupal']['databases']
if databases == nil || databases.empty? then
  databases = {
    'default/default' => {
      'driver' => 'mysql',
      'database' => node['drupal']['database'],
      'username' => node['drupal']['db_username'],
      'password' => node['drupal']['db_password'],
      'host' => node['drupal']['db_host'] || node['lamp']['database']['host'],
      'prefix' => ''
    }
  }
  node.override['drupal']['databases'] = databases
end

databases.each() do |key, map| 
  raise "Don't have a database name for db #{key}" unless map['database']  
  raise "Don't have a database host for db #{key}" unless map['host']
  raise "Don't have a username for db #{key}" unless map['username']
  raise "Don't have a password for db #{key}" unless map['password']
  raise "Unsupported driver for db #{key}" unless map['driver'] == 'mysql'

  mysql_connection_info = {
    :host     => 'localhost',
    :username => 'root',
    :password => node['lamp']['database']['root_password']
  }

  mysql_database map['database'] do
    connection mysql_connection_info
    action :create
  end
  
  if false then
    # Decide what host to limit access to.
    if map['host'] == 'localhost' then
      from_host = '127.0.0.1'
    elsif /^127\.[0-9.]+$/.match(map['host']) then
      from_host = map['host']
    else 
      from_host = node['ip_address']
    end  
  else
    from_host = '%'
  end

  mysql_database_user map['username'] do
    connection mysql_connection_info
    password map['password']
    host from_host
    action :create
  end

  mysql_database_user map['username'] do
    connection mysql_connection_info
    database_name map ['database']
    privileges [:select,:update,:insert,:delete,:create,:drop,:index,:alter,'create temporary tables']
    action :grant
  end
end
