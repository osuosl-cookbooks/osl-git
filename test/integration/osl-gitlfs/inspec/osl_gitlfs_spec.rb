describe package 'git' do
  it { should be_installed }
end

describe package 'git-lfs' do
  it { should be_installed }
end

describe directory('/foo/.git') do
  it { should exist }
end

describe file('/foo/osllogo.png') do
  it { should exist }
  its('size') { should eq 13011 }
end
