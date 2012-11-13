#
# Cookbook Name:: crowd
# Recipe:: server
#
# Copyright 2012, SecondMarket Labs, LLC
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

include_recipe "postgresql::client"
include_recipe "java::oracle"

execute "untar-crowd-tarball" do
  cwd node['crowd']['parentdir']
  command "tar zxf #{Chef::Config[:file_cache_path]}/#{node['crowd']['tarball']}"
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['crowd']['tarball']}" do
  source node['crowd']['url']
  action :nothing
  notifies :run, resources(:execute => "untar-crowd-tarball"), :immediately
end

http_request "HEAD #{node['crowd']['url']}" do
  message ""
  url node['crowd']['url']
  action :head
  if File.exists?("#{Chef::Config[:file_cache_path]}/#{node['crowd']['tarball']}")
    headers "If-Modified-Since" => File.mtime("#{Chef::Config[:file_cache_path]}/#{node['crowd']['tarball']}").httpdate
  end
  notifies :create, resources(:remote_file => "#{Chef::Config[:file_cache_path]}/#{node['crowd']['tarball']}"), :immediately
end

user "crowd" do
  comment "Atlassian Crowd"
  home node['crowd']['homedir']
  system true
  action :create
end

template "#{node['crowd']['homedir']}/crowd-webapp/WEB-INF/classes/crowd-init.properties" do
  source "crowd-init.properties.erb"
  variables(
    :crowd_home => node['crowd']['datadir']
  )
  owner "root"
  group "root"
  mode 00644
  action :create
end

directory node['crowd']['datadir'] do
  owner "crowd"
  mode 00755
  action :create
end

# The following fixups come from
# https://confluence.atlassian.com/display/CROWD/Setting+Crowd+to+Run+Automatically+and+Use+an+Unprivileged+System+User+on+UNIX - basically converted that bash script into a Chef recipe

%w{build.sh start_crowd.sh stop_crowd.sh apache-tomcat/bin/catalina.sh apache-tomcat/bin/setenv.sh apache-tomcat/bin/tool-wrapper.sh apache-tomcat/bin/digest.sh apache-tomcat/bin/shutdown.sh apache-tomcat/bin/version.sh apache-tomcat/bin/setclasspath.sh apache-tomcat/bin/startup.sh}.each do |s|
  file "#{node['crowd']['homedir']}/#{s}" do
    group "crowd"
    mode  00755
    action :create
  end
end

%w{logs temp work}.each do |d|
  directory "#{node['crowd']['homedir']}/apache-tomcat/#{d}" do
    owner "crowd"
    action :create
  end
end

file "#{node['crowd']['homedir']}/atlassian-crowd-openid-server.log" do
  owner "crowd"
  group "crowd"
  mode  00644
  action :create_if_missing
end

directory "#{node['crowd']['homedir']}/database" do
  owner "crowd"
  group "crowd"
  mode  00755
  action :create
end

template "/etc/init.d/crowd" do
  source "crowd.init.erb"
  owner "root"
  group "root"
  mode  00755
  action :create
  variables(
    :crowd_install_dir => node['crowd']['homedir']
  )
end

service "crowd" do
  supports :restart => true
  action [ :enable, :start ]
end
