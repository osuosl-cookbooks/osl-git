describe package('git') do
  it { should_not be_installed }
end

describe package('git224') do
  it { should be_installed }
end

describe command('git --version') do
  its('stdout') { should match /git version 2.24/ }
end
