#
# Cookbook Name:: drupal
# Recipe:: drupal_php
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

# These settings are recommended by the Drupal PHP page
node.normal['php']['directives'] = {
  'session.cache_limiter' => 'nocache',
  'session.auto_start' => '0',
  'expose_php' => 'off',
  'allow_url_fopen' => 'off',
  'magic_quotes_gpc' => 'off',
  'register_globals' => 'off',
  'display_errors' => 'Off'
}


include_recipe "php::default"


if platform_family?('debian') then
  # The php5-mysql package includes both myqsl and mysqli drivers
  extra_packages = ['php5-mysql', 'php5-json', 'php5-gd']
elsif platform_family?('fedora', 'rhel') then
  # There is no php-json package, but for rhel 6 and later 
  # php has json enabled by default.  If necessary:
  # $ yum install php-devel php-pear gcc
  # $ pecl install json
  extra_packages = ['php-mysqli', 'php-gd']
else
  raise "Unsupported platform #{node['platform']}"
end

extra_packages.each() do |pkg|
  package pkg do
    action :install
  end
end

