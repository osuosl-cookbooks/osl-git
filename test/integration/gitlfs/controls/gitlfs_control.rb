control 'gitlfs' do
  title 'Verify git-lfs is installed'

  describe package('git-lfs') do
    it { should be_installed }
  end

  describe command('git lfs env') do
    its('stdout') { should match %r{git-lfs/[0-9]+.[0-9]+.[0-9]+} }
  end
end
