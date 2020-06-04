#
# Cookbook:: osl-git-test
# Recipe:: chefspec_osl_gitlfs
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

node.default['osl-git-test']['action'] = :sync
node.default['osl-git-test']['directory'] = '/foo'
node.default['osl-git-test']['repository'] = 'git@github.com:foo.git'
node.default['osl-git-test']['repo_name'] = 'foo'

osl_gitlfs node['osl-git-test']['repo_name'] do
  directory node['osl-git-test']['directory']
  repository node['osl-git-test']['repository']
end
