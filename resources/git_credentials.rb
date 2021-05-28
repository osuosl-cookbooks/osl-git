resource_name :git_credentials
provides :git_credentials

property :path,  String, default: lazy { |r| Dir.home(r.owner) + '/.git-credentials' }
property :owner, String, name_property: true
property :group, String, default: 'root'
property :secrets_databag, String, default: lazy { node['osl-git']['secrets_databag'] }
property :secrets_item,    String, default: lazy { node['osl-git']['secrets_item'] }
property :use_http_path, [true, false], default: true

unified_mode true

default_action :create

action :create do
  git_config 'credential.useHttpPath' do
    value new_resource.use_http_path.to_s
    scope 'global'
    user  new_resource.owner
    group new_resource.group
  end

  git_config 'credential.helper' do
    value "store --file #{new_resource.path}"
    scope 'global'
    user  new_resource.owner
    group new_resource.group
  end

  template new_resource.path do
    cookbook 'osl-git'
    source 'git-credentials.erb'
    sensitive true
    owner new_resource.owner
    group new_resource.group

    secrets = git_credential_secrets(new_resource.secrets_databag, new_resource.secrets_item)
    variables(credentials: secrets['credentials']) unless secrets['credentials'].empty?

    action :create
  end
end

action :delete do
  execute 'git config --global --unset-all credential.helper' do
    user new_resource.owner
    group new_resource.group
    environment 'HOME' => Dir.home(new_resource.owner)
  end

  file new_resource.path do
    action :delete
  end
end
