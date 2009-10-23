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
    wget http://sysoev.ru/nginx/nginx-0.7.62.tar.gz
    tar -zxf nginx-0.7.62.tar.gz
    passenger-install-nginx-module --auto --nginx-source-dir=/tmp/nginx-0.7.62 --extra-configure-flags=--with-http_ssl_module --prefix=#{node[:nginx][:dir]}
    EOH
  end
  
  bash "remove default nginx.conf" do
    code "rm #{node[:nginx][:dir]}/conf/nginx.conf"
  end

  template "#{node[:nginx][:dir]}/conf/nginx.conf" do
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode 0644
  end
end

