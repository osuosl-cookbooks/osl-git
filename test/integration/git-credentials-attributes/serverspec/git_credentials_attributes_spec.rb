describe package 'git' do
  it { should be_installed }
end

describe file '/root/.git-credentials' do
  it { should be_file }
  its('owner') { should be 'root' }
  its('group') { should be 'root' }
  its('mode') { should be '0600' }
  [
    %r{https://user:pass@example.net/hello/world.git},
    %r{ssh://foo:bar@example.org/foo/bar.git},
  ].each do |line|
    its('content') { should match line }
  end
end

describe file '/root/.gitconfig' do
  it { should be_file }
  its('owner') { should be 'root' }
  its('group') { should be 'root' }
  its('content') { should match %r{helper = store --file /root/\.git-credentials} }
  its('content') { should match(/useHttpPath = true/) }
end

describe file '/root/test/.git' do
  it { should be_directory }
end

describe file '/home/foo/.git-credentials' do
  it { should be_file }
  its('owner') { should be 'foo' }
  its('group') { should be 'foo' }
  its('mode') { should be '0600' }
  [
    %r{https://user:pass@example.net/hello/world.git},
    %r{ssh://foo:bar@example.org/foo/bar.git},
  ].each do |line|
    its('content') { should match line }
  end
end

describe file '/home/foo/.gitconfig' do
  it { should be_file }
  its('owner') { should be 'foo' }
  its('group') { should be 'foo' }
  its('content') { should match %r{helper = store --file /home/foo/\.git-credentials} }
  its('content') { should match(/useHttpPath = false/) }
end

describe file '/home/bar/.git-credentials' do
  it { should_not exist }
end

describe file '/home/bar/.gitconfig' do
  it { should be_file }
  its('owner') { should be 'bar' }
  its('group') { should be 'bar' }
  its('content') { should_not match(/helper/) }
  its('content') { should_not match(/useHttpPath/) }
end
