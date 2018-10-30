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
    %r{bar:foo@example.xyz},
  ].each do |line|
    its(:content) { should match line }
  end
end

describe file '/root/.gitconfig' do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match %r{helper = store --file /root/\.git-credentials} }
end

describe file '/root/test/.git' do
  it { should be_directory }
end

describe file '/home/foo/.git-credentials' do
  it { should be_file }
  it { should be_owned_by     'foo' }
  it { should be_grouped_into 'bar' }
  it { should be_mode '640' }
  [
    %r{https://username:secret@example.456},
    %r{foobar:barfoo@example.abc},
  ].each do |line|
    its(:content) { should match line }
  end
end

describe file '/home/foo/.gitconfig' do
  it { should be_file }
  it { should be_owned_by     'foo' }
  it { should be_grouped_into 'bar' }
  its(:content) { should match %r{helper = store --file /home/foo/\.git-credentials} }
end

describe file '/home/bar/.git-credentials' do
  it { should_not exist }
end

describe file '/home/bar/.gitconfig' do
  it { should be_file }
  it { should be_owned_by 'bar' }
  its(:content) { should_not match(/helper/) }
end
