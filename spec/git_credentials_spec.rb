require_relative 'spec_helper'

describe 'osl-git-test::chefspec_git_credentials' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p.merge(step_into: 'git_credentials')).converge(described_recipe)
      end
      before do
        allow(Dir).to receive(:home).and_call_original
        allow(Dir).to receive(:home).with('foo').and_return('/home/foo')
        allow(Dir).to receive(:home).with('root').and_return('/root')
        stub_data_bag('databag').and_return(%w(item item2))
        stub_data_bag_item('databag', 'item').and_return(credentials: %w(foo bar))
        stub_data_bag_item('databag', 'item2').and_return(credentials: %w(hello world))
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_git_credentials('root').with(
          path: '/root/.git-credentials',
          owner: 'root',
          secrets_databag: 'databag',
          secrets_item: 'item',
          use_http_path: true
        )
      end
      it do
        expect(chef_run).to set_git_config('credential.useHttpPath').with(
          value: 'true',
          scope: 'global',
          user: 'root'
        )
      end
      it do
        expect(chef_run).to set_git_config('credential.helper').with(
          value: 'store --file /root/.git-credentials',
          scope: 'global',
          user: 'root'
        )
      end
      it do
        expect(chef_run).to create_template('/root/.git-credentials').with(
          cookbook: 'osl-git',
          source: 'git-credentials.erb',
          sensitive: true,
          owner: 'root',
          variables: { credentials: %w(foo bar) }
        )
      end
      it do
        expect(chef_run).to render_file('/root/.git-credentials').with_content(/^foo$\n^bar$/)
      end
      context 'useHttpPath disabled' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.merge(step_into: 'git_credentials')) do |node|
            node.normal['osl-git-test']['use_http_path'] = false
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to create_git_credentials('root').with(
            path: '/root/.git-credentials',
            owner: 'root',
            secrets_databag: 'databag',
            secrets_item: 'item',
            use_http_path: false
          )
        end
        it do
          expect(chef_run).to set_git_config('credential.useHttpPath').with(
            value: 'false',
            scope: 'global',
            user: 'root'
          )
        end
      end
      context 'different owner' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.merge(step_into: 'git_credentials')) do |node|
            node.normal['osl-git-test']['owner'] = 'foo'
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to create_git_credentials('foo').with(
            path: '/home/foo/.git-credentials',
            owner: 'foo',
            secrets_databag: 'databag',
            secrets_item: 'item',
            use_http_path: true
          )
        end
        it do
          expect(chef_run).to set_git_config('credential.useHttpPath').with(
            value: 'true',
            scope: 'global',
            user: 'foo'
          )
        end
        it do
          expect(chef_run).to set_git_config('credential.helper').with(
            value: 'store --file /home/foo/.git-credentials',
            scope: 'global',
            user: 'foo'
          )
        end
        it do
          expect(chef_run).to create_template('/home/foo/.git-credentials').with(
            cookbook: 'osl-git',
            source: 'git-credentials.erb',
            sensitive: true,
            owner: 'foo',
            variables: { credentials: %w(foo bar) }
          )
        end
        it do
          expect(chef_run).to render_file('/home/foo/.git-credentials').with_content(/^foo$\n^bar$/)
        end
      end
      context 'different databag item' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.merge(step_into: 'git_credentials')) do |node|
            node.normal['osl-git-test']['secrets_item'] = 'item2'
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to create_git_credentials('root').with(
            path: '/root/.git-credentials',
            owner: 'root',
            secrets_databag: 'databag',
            secrets_item: 'item2',
            use_http_path: true
          )
        end
        it do
          expect(chef_run).to create_template('/root/.git-credentials').with(
            cookbook: 'osl-git',
            source: 'git-credentials.erb',
            sensitive: true,
            owner: 'root',
            variables: { credentials: %w(hello world) }
          )
        end
        it do
          expect(chef_run).to render_file('/root/.git-credentials').with_content(/^hello$\n^world$/)
        end
      end
      context 'delete action' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.merge(step_into: 'git_credentials')) do |node|
            node.normal['osl-git-test']['action'] = :delete
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to delete_git_credentials('root').with(
            path: '/root/.git-credentials',
            owner: 'root',
            secrets_databag: 'databag',
            secrets_item: 'item',
            use_http_path: true
          )
        end
        it do
          expect(chef_run).to run_execute('git config --global --unset-all credential.helper').with(
            user: 'root',
            environment: { 'HOME' => '/root' }
          )
        end
        it do
          expect(chef_run).to delete_file('/root/.git-credentials')
        end
      end
    end
  end
end
