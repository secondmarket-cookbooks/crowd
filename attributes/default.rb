#
# Cookbook Name:: crowd
# Attributes:: default 
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

default['crowd']['version']='2.5.2'
default['crowd']['parentdir']='/opt'
default['crowd']['homedir']="#{node['crowd']['parentdir']}/atlassian-crowd-#{node['crowd']['version']}"
default['crowd']['tarball']="atlassian-crowd-#{node['crowd']['version']}.tar.gz"
default['crowd']['url']="http://www.atlassian.com/software/crowd/downloads/binary/#{node['crowd']['tarball']}"

default['crowd']['datadir']="/var/crowd-home"
