#
# Cookbook:: osl-git
# Spec:: ius
#
# Copyright:: 2020-2022, Oregon State University
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

describe 'osl-git::ius' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      case p
      when CENTOS_7
        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end

        it do
          expect(chef_run).to include_recipe('yum-ius')
        end

        it do
          expect(chef_run).to include_recipe('osl-selinux')
        end

        it do
          expect(chef_run).to install_git_client('ius git224').with(
            package_name: 'git224'
          )
        end

        context 'custom package' do
          cached(:chef_run) do
            ChefSpec::SoloRunner.new(p) do |node|
              node.normal['osl-git']['ius_git_package'] = 'git222'
            end.converge(described_recipe)
          end

          it do
            expect(chef_run).to install_git_client('ius git222').with(
              package_name: 'git222'
            )
          end
        end
      when ALMA_8, CENTOS_8
        it do
          expect { chef_run }.to raise_error('IUS is only supported on CentOS 7')
        end
      end
    end
  end
end
