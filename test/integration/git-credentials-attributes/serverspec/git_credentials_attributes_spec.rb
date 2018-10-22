require 'serverspec'

set :backend, :exec

describe package 'git' do
  it { should be_installed }
end

%w(.git-credentials
   .git-credentials-2).each do |f|
  describe file "/root/#{f}" do
    it { should be_file }
    it { should be_owned_by 'root' }
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
end

describe file '/root/test/.git' do
  it { should be_directory }
end
