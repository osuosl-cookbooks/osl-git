#
# Cookbook:: osl-git-test
# Recipe:: databag
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

# This recipe tests git credentials from databags

node.default['osl-git']['secrets_databag'] = 'osl-git'
node.default['osl-git']['secrets_item']    = 'item1'

git_credentials 'Default to fetching credentials from osl-git:item1 databag'

git_credentials 'Fetch credentials from different databag (testing accumulation)' do
  secrets_databag 'osl-git'
  secrets_item    'item2'
  notifies :sync, 'git[/root/test]'
end

# Test cloning a git repo that requires credentials
# (Add to one of the databags)
git '/root/test' do
  repository 'https://github.com/osuosl-cookbooks/test-cookbook.git'
  action :nothing
end
