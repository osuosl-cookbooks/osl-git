#
# Cookbook:: osl-git
# Recipe:: ius
#
# Copyright:: 2020-2023, Oregon State University
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
raise 'IUS is only supported on CentOS 7' if platform_family?('rhel') && node['platform_version'].to_i >= 8

include_recipe 'osl-selinux'
include_recipe 'yum-ius'

git_client "ius #{node['osl-git']['ius_git_package']}" do
  package_name node['osl-git']['ius_git_package']
end
