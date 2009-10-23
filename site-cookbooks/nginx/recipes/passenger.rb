#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2009, IT Thugs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unless File.exists?('/opt/nginx/conf/nginx.conf')
  script "install_nginx" do
    interpreter "bash"
    user "root"
    cwd "/tmp"
    code <<-EOH 
    wget #{node[:nginx][:fetch_url]}
    tar -zxf #{node[:nginx][:fetched_file]}
    passenger-install-nginx-module --auto --nginx-source-dir=/tmp/#{node[:nginx][:fetched_file].gsub(node[:nginx][:fetched_file_extension],'')} --extra-configure-flags=#{node[:nginx][:extra_configure_flags]} --prefix=#{node[:nginx][:dir]}
    ln -s #{node[:nginx][:dir]}/sbin/nginx /usr/bin/nginx
    rm -fR /tmp/#{node[:nginx][:fetched_file].gsub(node[:nginx][:fetched_file_extension],'')}
    rm -f #{node[:nginx][:fetched_file]}
    rm -f #{node[:nginx][:dir]}/conf/nginx.conf.default
    EOH
  end

  template "#{node[:nginx][:dir]}/conf/nginx.conf" do
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode 0644
  end
  
  template "/etc/init.d/nginx" do
    source "nginx.erb"
    owner "root"
    group "root"
    mode 0744
  end
  
  service "nginx" do
    supports [ :stop, :start, :restart, :reload ]
    action [ :enable, :start ]
  end
end

