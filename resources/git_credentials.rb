resource_name :git_credentials

property :path,  String, name_property: true
property :owner, String
property :group, String
property :mode, [String, Integer], default: '0600'
property :secrets_databag, String, default: node['osl-git']['secrets_databag']
property :secrets_item,    String, default: node['osl-git']['secrets_item']

default_action :create

action :create do
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
    mode  new_resource.mode

    secrets = git_credential_secrets(new_resource.secrets_databag, new_resource.secrets_item)
    variables['credentials'] = secrets['credentials'] unless secrets['credentials'].empty?

    action :create
  end
end

action :delete do
  execute 'git config --global --unset-all credential.helper'

  file new_resource.path do
    action :delete
  end
end
