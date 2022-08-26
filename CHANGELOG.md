osl-git CHANGELOG
=================
This file is used to list changes made in each version of the
osl-git cookbook.

1.10.0 (2022-08-26)
-------------------
- Migrate base::gitlfs to this cookbook

1.9.1 (2021-11-23)
------------------
- Ensure git lfs is properly installed in a repo

1.9.0 (2021-09-02)
------------------
- Run git lfs pull command as specified user

1.8.0 (2021-06-14)
------------------
- Enable Selinux Enforcing

1.7.0 (2021-06-11)
------------------
- Chef 17 Fixes

1.6.0 (2021-04-08)
------------------
- Update Chef dependency to >= 16

1.5.0 (2020-09-14)
------------------
- Add user, group, and timeout properties to osl_gitlfs resource

1.4.0 (2020-09-02)
------------------
- Chef 16 update

1.3.1 (2020-08-11)
------------------
- Centos 8 update

1.3.0 (2020-08-04)
------------------
- Add recipe to install git from IUS repo

1.2.1 (2020-07-07)
------------------
- Update osl_gitlfs to be idempotent

1.2.0 (2020-07-01)
------------------
- Chef 15 Fixes

1.1.0 (2020-06-15)
------------------
- osl_gitlfs custom resource

1.0.4 (2020-06-02)
------------------
- Remove comment from git credential template

1.0.3 (2019-12-23)
------------------
- Chef 14 post-migration fixes

1.0.2 (2019-01-15)
------------------
- Add group parameter to git_credential resource

1.0.1 (2018-12-05)
------------------
- Use lazy eval for params that default to attributes

1.0.0 (2018-11-01)
------------------
- Create git_credentials resource for git credential helper store

0.1.0
-----
- Initial release of osl-git

