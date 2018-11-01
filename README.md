osl-git Cookbook
================
This cookbook wraps the [git](https://supermarket.chef.io/cookbooks/git) cookbook for use at the
Open Source Lab.

It installs git and offers a `git_credentials` resource for saving credentials within the
[git credential store](https://git-scm.com/docs/git-credential-store).

Requirements
------------

#### Cookbooks
- [git](https://supermarket.chef.io/cookbooks/git)

#### Platforms
- CentOS 7

Attributes
----------
<table> <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['osl-git']['secrets_databag']</tt></td>
    <td>String</td>
    <td>Default databag for git_credentials to use</td>
    <td><tt>'databag'</tt></td>
  </tr>
  <tr>
    <td><tt>['osl-git']['secrets_item']</tt></td>
    <td>String</td>
    <td>Default databag item for git_credentials to use</td>
    <td><tt>'item'</tt></td>
  </tr>
  <tr>
    <td><tt>['osl-git']['secrets']['credentials']</tt></td>
    <td>String</td>
    <td>Don't use in production! Source for git_credentials to fall back to when databags are unavailable.</td>
    <td><tt>[]</tt></td>
  </tr>
</table>

Recipes
-------

#### osl-git::default
Installs git.

Resources
---------

### git_credentials
Enables the [git credential store](https://git-scm.com/docs/git-credential-store) and stores
credentials in the specified file.

**In production** credentials are specified in a databag item. When the databag item properties
are not specified in the resource, these default to attributes:
specified by this cookbook's attributes:
* `node['osl-git']['secrets_databag']` 
* `node['osl-git']['secrets_item']`

**When testing** credentials are read from attributes when databags are unavailable:
* `node['osl-git']['secrets]'['credentials']`

The logic for choosing databags vs attributes is in `libraries/default.rb`

The full syntax for all of the resource's properties is:
```ruby
git_credentials 'name' do
  path                 String # default value: ~/.git-credentials
  owner                String # defaults to 'name' if not specified
  secrets_databag      String # default value: node['osl-git']['secrets_databag']
  secrets_item         String # default value: node['osl-git']['secrets_item']
  action               Symbol # defaults to :create
end
```

An example where git credentials is used with an explicitly specified databag:
```ruby
git_credentials 'root' do
  path '/root/.git-credentials'
  secrets_databag 'secrets'
  secrets_item 'git_tokens'
  use_http_path true
end
```

#### Actions
`:create`

Enable the git credentials store in the global git configuration and populate `path` with
credentials from `secrets_databag:secrets_item` (or from
`node['osl-git']['secrets']['credentials']` in a testing environment).

`:delete`

Delete the credentials file at `path` and disable the git credential store in the global git
configuration.

`:nothing`

Do nothing until notified by another resource.

#### Properties
`path` - **Ruby Type:** String | **Default Value:** '~/.git-credentials'

The path to the file where git credentials are stored.

`owner` - **Ruby Type:** String

The user who's git configuration will be updated and the owner of the git credentials store file.

`secrets_databag` - **Ruby Type:** String | **Default Value:** `node['osl-git']['secrets_databag']`

The name of the databag where credentials are stored.

`secrets_item` - **Ruby Type:** String | **Default Value:** `node['osl-git']['secrets_item']`

The name of the databag item where credentials are stored.

`use_http_path` - **Ruby Type:** Boolean | **Default Value:** true

Whether or not to match stored credentials by the repo path in the remote's URL. When enabled, only
credentials with a matching hostname and repo path will be applied. When disabled, only the
credentials hostname must match the remote.
[See git documentation on useHttpPath](https://git-scm.com/docs/gitcredentials#gitcredentials-useHttpPath)

Databag
-------
The `git_credentials` resource expects a `credentials` list in databag items:

```json
{
  "id": "git_tokens",
  "credentials": [
    "https://username:token@github.com/repo/path.git",
    "foo:bar@gitlab.com/project/repo.git"
  ]
}
```

The above example assumes `use_http_path` is enabled and includes repo paths in URLs.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `username/add_component_x`)
3. Write tests for your change
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
- Author:: Oregon State University <chef@osuosl.org>

```text
Copyright:: 2018, Oregon State University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
