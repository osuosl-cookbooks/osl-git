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
          repository: 'https://git.osuosl.org/osuosl/test-lfs.git',
          user: 'root',
          group: 'root',
          timeout: 500
        )
      end
      it do
        expect(chef_run).to sync_osl_gitlfs('/tmp/bar').with(
          destination: '/tmp/bar',
          repository: 'https://git.osuosl.org/osuosl/test-lfs.git',
          user: 'nobody',
          group: 'nobody',
          timeout: 300
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
        expect(chef_run).to sync_git('/tmp/bar').with(
          user: 'nobody',
          group: 'nobody',
          repository: 'https://git.osuosl.org/osuosl/test-lfs.git',
          environment: { 'GIT_LFS_SKIP_SMUDGE' => '1' }
        )
      end
      it do
        expect(chef_run.git('/foo')).to notify('execute[git lfs pull /foo]').to(:run)
      end
      it do
        expect(chef_run.git('/tmp/bar')).to notify('execute[git lfs pull /tmp/bar]').to(:run)
      end
      it do
        expect(chef_run).to run_execute('git lfs install /foo').with(
          user: 'root',
          group: 'root',
          login: true,
          cwd: '/foo',
          command: 'git lfs install'
        )
      end
      it do
        expect(chef_run).to run_execute('git lfs install /tmp/bar').with(
          user: 'nobody',
          group: 'nobody',
          login: true,
          cwd: '/tmp/bar',
          command: 'git lfs install'
        )
      end
      context 'git lfs already installed' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.merge(step_into: 'osl_gitlfs')).converge(described_recipe)
        end

        before do
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with('/foo/.git/hooks/pre-push').and_return(true)
          allow(File).to receive(:exist?).with('/tmp/bar/.git/hooks/pre-push').and_return(true)
          allow(File).to receive(:readlines).and_call_original
          allow(File).to receive(:readlines).with('/foo/.git/hooks/pre-push').and_return(%w(git-lfs))
          allow(File).to receive(:readlines).with('/tmp/bar/.git/hooks/pre-push').and_return(%w(git-lfs))
        end

        it do
          expect(chef_run).to_not run_execute('git lfs install /foo').with(
            user: 'root',
            group: 'root',
            login: true,
            cwd: '/foo',
            command: 'git lfs install'
          )
        end
        it do
          expect(chef_run).to_not run_execute('git lfs install /tmp/bar').with(
            user: 'nobody',
            group: 'nobody',
            login: true,
            cwd: '/tmp/bar',
            command: 'git lfs install'
          )
        end
      end
      it do
        expect(chef_run).to nothing_execute('git lfs pull /foo').with(
          user: 'root',
          group: 'root',
          login: true,
          cwd: '/foo',
          command: 'git lfs pull'
        )
      end
      it do
        expect(chef_run).to nothing_execute('git lfs pull /tmp/bar').with(
          user: 'nobody',
          group: 'nobody',
          login: true,
          cwd: '/tmp/bar',
          command: 'git lfs pull'
        )
      end
    end
  end
end
