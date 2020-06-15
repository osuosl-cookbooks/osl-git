require_relative 'spec_helper'

describe 'osl-git-test::osl_gitlfs' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.merge(step_into: 'osl_gitlfs')).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to sync_osl_gitlfs('/foo').with(
          destination: '/foo',
          repository: 'https://git.osuosl.org/osuosl/test-lfs.git'
        )
      end
      it do
        expect(chef_run).to include_recipe('base::gitlfs')
      end
      it do
        expect(chef_run).to include_recipe('git')
      end
      it do
        expect(chef_run).to sync_git('/foo').with(
          repository: 'https://git.osuosl.org/osuosl/test-lfs.git',
          environment: { 'GIT_LFS_SKIP_SMUDGE' => '1' }
        )
      end
      it do
        expect(chef_run).to run_execute('git lfs pull /foo').with(
          cwd: '/foo'
        )
      end
    end
  end
end
