#
# Cookbook:: osl-git-test
# Recipe:: attributes
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

# Tests git credentials when falling back to creds in attributes

git_credentials 'Using default file' do
  notifies :sync, 'git[/root/test]'
end

git_credentials 'Specifying file in property' do
  file '/root/.git-credentials-2'
end

# Test cloning a git repo that requires credentials
# (Use ENV variables referenced in attributes in .kitchen.yml)
git '/root/test' do
  repository 'https://github.com/osuosl-cookbooks/test-cookbook.git'
  action :nothing
end
