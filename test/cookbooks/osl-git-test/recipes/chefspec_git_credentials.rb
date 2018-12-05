#
# Cookbook:: osl-git-test
# Recipe:: chefspec_git_credentials
#
# Copyright:: 2018, Oregon State University
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

# This recipe creates a git_credentials resource for testing in ChefSpec.
# Attributes allow changing values for different test contexts.

node.default['osl-git-test']['action'] = :create
node.default['osl-git-test']['owner'] = 'root'
node.default['osl-git-test']['secrets_item'] = 'item'
node.default['osl-git-test']['use_http_path'] = true

git_credentials node['osl-git-test']['owner'] do
  use_http_path node['osl-git-test']['use_http_path']
  secrets_item node['osl-git-test']['secrets_item']
  action node['osl-git-test']['action']
end
