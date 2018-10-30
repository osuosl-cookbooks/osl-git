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

**In production** credentials are specified in a databag item, defaulting to the item
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
  group                String
  mode                 String, Integer # default value: 0600
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
end
```

#### Actions
`:create`

Enable the git credentials store and populates `file` with credentials from
`secrets_databag:secrets_item` (or from `node['osl-git']['secrets']['credentials']` in a
testing environment).

`:delete`

Delete the git credentials store file and removes it from the global git configuration.

`:nothing`

Do nothing until notified by another resource.

#### Properties
`path` - **Ruby Type:** String | **Default Value:** '~/.git-credentials'

The path to the file where git credentials will be stored.

`owner` - **Ruby Type:** String

The name of the user that owns the git credentials store file and the user who's git configuration
will be updated.

`group` - **Ruby Type:** String

The name of the group belonging to the git credentials store file and git configuration. If
unspecified, the existing group won't change or a new file will be created using the default POSIX
group.

`mode` - **Ruby Type:** String, Integer | **Default Value::** '0600'

The mode of the git credentials store file.

`secrets_databag` - **Ruby Type:** String | **Default Value:** `node['osl-git']['secrets_databag']`

The name of the databag where credentials are stored.

`secrets_item` - **Ruby Type:** String | **Default Value:** `node['osl-git']['secrets_item']`

The name of the databag item where credentials are stored.

Databag
-------
The `git_credentials` resource expects a `credentials` list in databag items:

```json
{
  "id": "git_tokens",
  "credentials": [
    "https://username:token@github.com",
    "foo:bar@gitlab.com"
  ]
}
```

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
