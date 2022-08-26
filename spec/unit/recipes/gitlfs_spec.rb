#
# Cookbook:: osl-git
# Spec:: gitlfs
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

require_relative '../../spec_helper'

describe 'osl-git::gitlfs' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to add_osl_packagecloud_repo('github/git-lfs')
      end
      it do
        expect(chef_run).to_not create_yum_repository('git-lfs')
      end
      it do
        expect(chef_run).to install_package('git-lfs')
      end
      context 'setting arch to aarch64' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.automatic['kernel']['machine'] = 'aarch64'
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to_not add_osl_packagecloud_repo('github/git-lfs')
        end
        it do
          expect(chef_run).to create_yum_repository('git-lfs')
            .with(
              description: 'OSL git-lfs aarch64 repo',
              gpgkey: 'http://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl',
              gpgcheck: true,
              baseurl: 'http://ftp.osuosl.org/pub/osl/repos/yum/$releasever/git-lfs/$basearch'
            )
        end
      end
      context 'setting arch to ppc64le' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.automatic['kernel']['machine'] = 'ppc64le'
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to create_yum_repository('git-lfs')
            .with(
              description: 'OSL git-lfs ppc64le repo',
              gpgkey: 'http://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl',
              gpgcheck: true,
              baseurl: 'http://ftp.osuosl.org/pub/osl/repos/yum/$releasever/git-lfs/$basearch'
            )
        end
        it do
          expect(chef_run).to_not add_osl_packagecloud_repo('github/git-lfs')
        end
      end
      context 'setting arch to s390x' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.automatic['kernel']['machine'] = 's390x'
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to create_yum_repository('git-lfs')
            .with(
              description: 'OSL git-lfs s390x repo',
              gpgkey: 'http://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl',
              gpgcheck: true,
              baseurl: 'http://ftp.osuosl.org/pub/osl/repos/yum/$releasever/git-lfs/$basearch'
            )
        end
        it do
          expect(chef_run).to_not add_osl_packagecloud_repo('github/git-lfs')
        end
      end
    end
  end
end
