resource_name :osl_gitlfs
provides :osl_gitlfs
unified_mode true

default_action :sync

provides :osl_gitlfs
property :destination, String, name_property: true
property :repository, String
property :user, [String, Integer], default: 'root'
property :group, [String, Integer], default: 'root'
property :timeout, Integer, default: 500

action :sync do
  run_context.include_recipe 'osl-git'

  git new_resource.destination do
    repository new_resource.repository
    environment('GIT_LFS_SKIP_SMUDGE' => '1')
    notifies :run, "execute[git lfs pull #{new_resource.name}]", :immediately
    user new_resource.user
    group new_resource.group
    timeout new_resource.timeout
  end

  execute "git lfs pull #{new_resource.name}" do
    action :nothing
    command 'git lfs pull'
    cwd new_resource.destination
  end
end
