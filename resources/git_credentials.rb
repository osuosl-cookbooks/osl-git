resource_name :git_credentials
provides :git_credentials
unified_mode true

property :path,  String, default: lazy { |r| Dir.home(r.owner) + '/.git-credentials' }
property :owner, String, name_property: true
property :group, String, default: 'root'
property :secrets_databag, String, default: lazy { node['osl-git']['secrets_databag'] }
property :secrets_item,    String, default: lazy { node['osl-git']['secrets_item'] }
property :use_http_path, [true, false], default: true

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

  secrets = git_credential_secrets(new_resource.secrets_databag, new_resource.secrets_item)

  secrets['credentials'].each do |cred|
    append_if_no_line "add credential for #{new_resource.owner} for #{Digest::SHA256.hexdigest(cred)[0..8]}" do
      path new_resource.path
      mode '0600'
      owner new_resource.owner
      group new_resource.group
      sensitive true
      line cred.gsub(/\+/, '%2b')
    end
  end
end

action :delete do
  execute 'git config --global --unset-all credential.helper' do
    user new_resource.owner
    group new_resource.group
    environment 'HOME' => Dir.home(new_resource.owner)
    only_if { ::File.exist?(new_resource.path) }
  end

  file new_resource.path do
    sensitive true
    action :delete
  end
end
