describe package 'git' do
  it { should be_installed }
end

describe package 'git-lfs' do
  it { should be_installed }
end

describe directory('/foo/.git') do
  it { should exist }
end

describe directory('/tmp/bar/.git') do
  it { should exist }
  its('owner') { should eq 'nobody' }
  its('group') { should eq 'nobody' }
end

describe file('/foo/osllogo.png') do
  it { should exist }
  its('size') { should eq 13011 }
end

describe file('/tmp/bar/osllogo.png') do
  it { should exist }
  its('owner') { should eq 'nobody' }
  its('group') { should eq 'nobody' }
  its('size') { should eq 13011 }
end
