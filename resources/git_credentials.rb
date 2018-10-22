resource_name :git_credentials

property :file, String, default: '/root/.git-credentials'
property :secrets_databag, String, default: node['osl-git']['secrets_databag']
property :secrets_item, String, default: node['osl-git']['secrets_item']

default_action :create

action :create do
  with_run_context :root do
    execute "git config --global credential.helper 'store --file #{new_resource.file}'"

    edit_resource(:template, new_resource.file) do |new_resource|
      cookbook 'osl-git'
      source 'git-credentials.erb'
      mode '0600'

      secrets = git_credential_secrets(new_resource.secrets_databag, new_resource.secrets_item)

      unless secrets['credentials'].empty?
        variables['credentials'] ||= []
        variables['credentials'] << secrets['credentials']
        variables['credentials'] = variables['credentials'].flatten.uniq
      end

      action :nothing
      delayed_action :create
      notifies :trigger, new_resource, :immediately
    end
  end
end

action :trigger do
  new_resource.updated_by_last_action(true)
end
