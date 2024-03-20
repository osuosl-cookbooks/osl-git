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
          group: 'root',
          secrets_databag: 'databag',
          secrets_item: 'item',
          use_http_path: true
        )
      end
      it do
        expect(chef_run).to set_git_config('credential.useHttpPath').with(
          value: 'true',
          scope: 'global',
          user: 'root',
          group: 'root'
        )
      end
      it do
        expect(chef_run).to set_git_config('credential.helper').with(
          value: 'store --file /root/.git-credentials',
          scope: 'global',
          user: 'root',
          group: 'root'
        )
      end

      it do
        expect(chef_run).to edit_append_if_no_line('add credential for root for 2c26b46b6').with(
          sensitive: true,
          owner: 'root',
          group: 'root',
          mode: '0600',
          line: 'foo'
        )
      end

      it do
        expect(chef_run).to edit_append_if_no_line('add credential for root for fcde2b2ed').with(
          sensitive: true,
          owner: 'root',
          group: 'root',
          mode: '0600',
          line: 'bar'
        )
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
            group: 'root',
            secrets_databag: 'databag',
            secrets_item: 'item',
            use_http_path: false
          )
        end
        it do
          expect(chef_run).to set_git_config('credential.useHttpPath').with(
            value: 'false',
            scope: 'global',
            user: 'root',
            group: 'root'
          )
        end
      end
      context 'different owner' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.merge(step_into: 'git_credentials')) do |node|
            node.normal['osl-git-test']['owner'] = 'foo'
            node.normal['osl-git-test']['group'] = 'foo'
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to create_git_credentials('foo').with(
            path: '/home/foo/.git-credentials',
            owner: 'foo',
            group: 'foo',
            secrets_databag: 'databag',
            secrets_item: 'item',
            use_http_path: true
          )
        end
        it do
          expect(chef_run).to set_git_config('credential.useHttpPath').with(
            value: 'true',
            scope: 'global',
            user: 'foo',
            group: 'foo'
          )
        end
        it do
          expect(chef_run).to set_git_config('credential.helper').with(
            value: 'store --file /home/foo/.git-credentials',
            scope: 'global',
            user: 'foo',
            group: 'foo'
          )
        end
        it do
          expect(chef_run).to edit_append_if_no_line('add credential for foo for 2c26b46b6').with(
            sensitive: true,
            owner: 'foo',
            group: 'foo',
            mode: '0600',
            line: 'foo'
          )
        end

        it do
          expect(chef_run).to edit_append_if_no_line('add credential for foo for fcde2b2ed').with(
            sensitive: true,
            owner: 'foo',
            group: 'foo',
            mode: '0600',
            line: 'bar'
          )
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
            group: 'root',
            secrets_databag: 'databag',
            secrets_item: 'item2',
            use_http_path: true
          )
        end
        it do
          expect(chef_run).to edit_append_if_no_line('add credential for root for 2cf24dba5').with(
            sensitive: true,
            owner: 'root',
            group: 'root',
            mode: '0600',
            line: 'hello'
          )
        end

        it do
          expect(chef_run).to edit_append_if_no_line('add credential for root for 486ea4622').with(
            sensitive: true,
            owner: 'root',
            group: 'root',
            mode: '0600',
            line: 'world'
          )
        end
      end
      context 'delete action' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p.merge(step_into: 'git_credentials')) do |node|
            node.normal['osl-git-test']['action'] = :delete
          end.converge(described_recipe)
        end
        before do
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?).with('/root/.git-credentials').and_return(true)
        end
        it do
          expect(chef_run).to delete_git_credentials('root').with(
            path: '/root/.git-credentials',
            owner: 'root',
            group: 'root',
            secrets_databag: 'databag',
            secrets_item: 'item',
            use_http_path: true
          )
        end
        it do
          expect(chef_run).to run_execute('git config --global --unset-all credential.helper').with(
            user: 'root',
            group: 'root',
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
