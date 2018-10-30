resource_name :git_credentials

property :path,  String, default: lazy { |r| Dir.home(r.owner) + '/.git-credentials' }
property :owner, String, name_property: true
property :secrets_databag, String, default: node['osl-git']['secrets_databag']
property :secrets_item,    String, default: node['osl-git']['secrets_item']

default_action :create

action :create do
  git_config 'credential.helper' do
    value "store --file #{new_resource.path}"
    scope 'global'
    user  new_resource.owner
  end

  template new_resource.path do
    cookbook 'osl-git'
    source 'git-credentials.erb'
    sensitive true
    owner new_resource.owner

    secrets = git_credential_secrets(new_resource.secrets_databag, new_resource.secrets_item)
    variables(credentials: secrets['credentials']) unless secrets['credentials'].empty?

    action :create
  end
end

action :delete do
  execute 'git config --global --unset-all credential.helper' do
    user new_resource.owner
    environment ({'HOME' => Dir.home(new_resource.owner)})
  end

  file new_resource.path do
    action :delete
  end
end
