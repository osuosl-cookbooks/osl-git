resource_name :osl_gitlfs

default_action :checkout

provides :osl_gitlfs
property :repository, String

action :checkout do

  run_context.include_recipe 'base::gitlfs'

  bash do
    cwd new_resource.name
    code "git clone #{new_resource.repository}" 
    environment ({"GIT_LFS_SKIP_SMUDGE" => "1"})
  end

  bash do
    cwd new_resource.name
    code "git lfs checkout"
  end

end
