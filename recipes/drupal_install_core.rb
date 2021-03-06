#
# Cookbook Name:: drupal
# Recipe:: drupal_install_core
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

::Chef::Recipe.send(:include, ScrapeUrl)

cache = Chef::Config[:file_cache_path]
version = node['drupal']['version'] || 'latest'
page_url = node['drupal']['download_page'] || 
  'https://www.drupal.org/project/drupal'
install_dir = node['apache']['docroot_dir'] 

case version 
when 'latest', '7' then
  url = scrapeUrl(/drupal-7\.\d+\.tar\.gz/, page_url)
when '6' then
  url = scrapeUrl(/drupal-6\.\d+\.tar\.gz/, page_url)
when '7.x-dev', 'dev' then
  url = scrapeUrl(/drupal-7\.x.tar\.gz/, page_url)
when '6.x-dev' then
  url = scrapeUrl(/drupal-6\.x.tar\.gz/, page_url)
else
  url = "http://ftp.drupal.org/files/projects/drupal-#{version}.tar.gz"
end

archive = /.*\/(.*)$/.match(url)[1]
drupal_root = /^(.*)\.tar\.gz/.match(archive)[1]

package 'tar' do
end

remote_file "#{cache}/#{archive}" do
  source url 
end

bash "extract #{archive}" do
  code <<EOF
    tar -xzf #{cache}/#{archive}
    cd #{drupal_root}
    mv * .htaccess .gitignore ..
    cd ..
    rmdir #{drupal_root}
EOF
  cwd install_dir
end
