#
# Cookbook:: osl-git-test
# Recipe:: databag
#
# Copyright:: 2018-2024, Oregon State University
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
# This recipe tests git credentials from databags

node.default['osl-git']['secrets_databag'] = 'osl-git'
node.default['osl-git']['secrets_item']    = 'item1'

# Testing default properties
git_credentials 'root'

git_credentials 'root-additional' do
  owner 'root'
  secrets_item 'item3'
end

git '/root/test' do
  user 'root'
  repository 'https://git.osuosl.org/osuosl/test.git'
end

# Testing non-default properties
group 'foo'

user 'foo' do
  group 'foo'
  manage_home true
end

git_credentials 'foo' do
  group 'foo'
  use_http_path false
  secrets_item 'item2'
end

git '/home/foo/test' do
  user 'foo'
  group 'foo'
  repository 'https://git.osuosl.org/osuosl/test.git'
end

# Testing :delete action
group 'bar'

user 'bar' do
  group 'bar'
  manage_home true
end

git_credentials 'bar' do
  group 'bar'
  action :delete
end
