describe package 'git' do
  it { should be_installed }
end

describe file '/root/.git-credentials' do
  it { should be_file }
  its('owner') { should eq 'root' }
  its('mode') { should cmp '0600' }
  [
    %r{https://name:token@example.123/hello/world.git},
    %r{https://bar:foo@example.xyz/foo/bar.git},
    %r{https://username:secret@example\.789},
    %r{https://gitlab%2bdeploy-token-13:CWN8Fsjrtare7yAHkknj@git\.osuosl\.org/osuosl/test\.git},
  ].each do |line|
    its('content') { should match line }
  end
end

describe file '/root/.gitconfig' do
  it { should be_file }
  its('owner') { should eq 'root' }
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
  its('mode') { should cmp '0600' }
  [
    %r{https://username:secret@example.456},
    /foobar:barfoo@example.abc/,
  ].each do |line|
    its('content') { should match line }
  end
end

describe file '/home/foo/.gitconfig' do
  it { should be_file }
  its('owner') { should eq 'foo' }
end

describe ini('/home/foo/.gitconfig') do
  its('credential.helper') { should eq 'store --file /home/foo/.git-credentials' }
  its('credential.useHttpPath') { should eq 'false' }
end

describe file '/home/bar/.git-credentials' do
  it { should_not exist }
end

describe file '/home/bar/.gitconfig' do
  it { should_not exist }
end
