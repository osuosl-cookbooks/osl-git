require_relative '../../spec_helper'

describe 'osl-git::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to include_recipe 'osl-selinux'
      end
      it do
        if ALL_DEBIAN.include?(p)
          expect(chef_run).to periodic_apt_update('osl-git')
        else
          expect(chef_run).to_not periodic_apt_update('osl-git')
        end
      end
      it do
        expect(chef_run).to install_git_client('default')
      end
      it do
        expect(chef_run).to include_recipe 'osl-git::gitlfs'
      end
    end
  end
end
