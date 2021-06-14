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
        expect(chef_run).to include_recipe 'git'
      end
    end
  end
end
