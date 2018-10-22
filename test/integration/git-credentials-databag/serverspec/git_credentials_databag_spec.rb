require 'serverspec'

set :backend, :exec

describe package 'git' do
  it { should be_installed }
end

describe file '/root/.git-credentials' do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '600' }
  [
    %r{https://name:token@example.123},
    %r{ssh://bar:foo@example.xyz},
    /more:duplicates@example.abc/,
  ].each do |line|
    its(:content) { should match line }
  end
end

describe file '/root/test/.git' do
  it { should be_directory }
end
