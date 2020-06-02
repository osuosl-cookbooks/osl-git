resource_name :osl_gitlfs

default_action :sync

provides :osl_gitlfs
property :directory, String, required: true, name_property: true
property :repository, String, required: true

action :sync do

  run_context.include_recipe 'base::gitlfs'
  run_context.include_recipe 'git'

  git new_resource.directory do
    repository new_resource.repository
    environment ({"GIT_LFS_SKIP_SMUDGE" => "1"})
  end

  repo_folder = ::File.basename(new_resource.repository, ::File.extname(new_resource.repository))

  execute 'git lfs pull' do
    cwd "#{new_resource.directory}/#{repo_folder}"
  end

end
