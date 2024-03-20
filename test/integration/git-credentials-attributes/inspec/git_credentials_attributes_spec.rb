describe package 'git' do
  it { should be_installed }
end

describe file '/root/.git-credentials' do
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0600' }
  [
    %r{https://user:pass@example.net/hello/world.git},
    %r{ssh://foo:bar@example.org/foo/bar.git},
  ].each do |line|
    its('content') { should match line }
  end
end

describe file('/root/.gitconfig') do
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end

describe ini('/root/.gitconfig') do
  its('credential.helper') { should eq 'store --file /root/.git-credentials' }
  its('credential.useHttpPath') { should eq 'true' }
end

describe file '/root/test/.git' do
  it { should be_directory }
end

describe file '/home/foo/.git-credentials' do
  it { should be_file }
  its('owner') { should eq 'foo' }
  its('group') { should eq 'foo' }
  its('mode') { should cmp '0600' }
  [
    %r{https://user:pass@example.net/hello/world.git},
    %r{ssh://foo:bar@example.org/foo/bar.git},
  ].each do |line|
    its('content') { should match line }
  end
end

describe file '/home/foo/.gitconfig' do
  it { should be_file }
  its('owner') { should eq 'foo' }
  its('group') { should eq 'foo' }
end

describe ini '/home/foo/.gitconfig' do
  its('credential.helper') { should eq 'store --file /home/foo/.git-credentials' }
  its('credential.useHttpPath') { should eq 'true' }
end

describe file '/home/bar/.git-credentials' do
  it { should_not exist }
end

describe file '/home/bar/.gitconfig' do
  it { should_not exist }
end
