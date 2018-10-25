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
    %r{https://user:pass@example.net},
    %r{ssh://foo:bar@example.org},
    /test:duplicates@example.com/,
  ].each do |line|
    its(:content) { should match line }
  end
end

describe file '/root/test/.git' do
  it { should be_directory }
end

describe file '/home/foo/.git-credentials' do
  it { should be_file }
  it { should be_owned_by     'foo' }
  it { should be_grouped_into 'bar' }
  it { should be_mode '400' }
  [
    %r{https://user:pass@example.net},
    %r{ssh://foo:bar@example.org},
    /test:duplicates@example.com/,
  ].each do |line|
    its(:content) { should match line }
  end
end

describe file '/home/foo/.gitconfig' do
  its(:content) { should match %r{helper = store --file /home/foo/\.git-credentials} }
end

describe file '/root/.git-credentials-deleted' do
  it { should_not exist }
end

describe file '/root/.gitconfig' do
  its(:content) { should_not match(/helper/) }
end
