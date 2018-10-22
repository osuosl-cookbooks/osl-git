def git_credential_secrets(databag = node['osl-git']['secrets_databag'], item = node['osl-git']['secrets_item'])
  data_bag_item(
    databag,
    item
  )
rescue Net::HTTPServerException => e
  databag_item = "#{databag}:#{item}"
  if e.response.code == '404'
    Chef::Log.warn("Could not find databag '#{databag_item}'; falling back to default attributes.")
    node['osl-git']['secrets']
  else
    Chef::Log.fatal("Unable to load databag '#{databag_item}'; exiting. Please fix the databag and try again.")
    raise
  end
end
