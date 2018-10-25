require 'serverspec'

set :backend, :exec

describe package 'git' do
  it { should be_installed }
end

describe file '/root/.git-credentials' do
  it { should be_file }
  it { should be_owned_by     'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '600' }
  [
    %r{https://name:token@example.123},
    %r{ssh://bar:foo@example.xyz}
  ].each do |line|
    its(:content) { should match line }
  end
end

describe file '/root/.git-credentials-2' do
  it { should be_file }
  it { should be_owned_by     'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode '600' }
  its(:content) { should match(/more:duplicates@example.abc/) }
end

describe file '/root/.gitconfig' do
  its(:content) { should match %r{helper = store --file /root/\.git-credentials} }
  its(:content) { should match %r{helper = store --file /root/\.git-credentials-2} }
end

%w(test test2).each do |repo|
  describe file "/root/#{repo}/.git" do
    it { should be_directory }
  end
end
