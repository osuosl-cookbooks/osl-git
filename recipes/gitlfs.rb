#
# Cookbook:: osl-git
# Recipe:: gitlfs
#
# Copyright:: 2022, Oregon State University
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
osl_packagecloud_repo 'github/git-lfs' do
  only_if { %w(x86_64).include?(node['kernel']['machine']) }
end

yum_repository 'git-lfs' do
  description "OSL git-lfs #{node['kernel']['machine']} repo"
  gpgkey 'http://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl'
  gpgcheck true
  baseurl 'http://ftp.osuosl.org/pub/osl/repos/yum/$releasever/git-lfs/$basearch'
  only_if { %w(ppc64le s390x aarch64).include?(node['kernel']['machine']) }
end

package 'git-lfs'
