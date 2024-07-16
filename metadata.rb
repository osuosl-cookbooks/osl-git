name             'osl-git'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 16.0'
issues_url       'https://github.com/osuosl-cookbooks/osl-git/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-git'
description      'Installs/Configures osl-git'
version          '1.13.0'

depends          'git'
depends          'line'
depends          'osl-resources'
depends          'osl-selinux'

supports         'almalinux', '~> 8.0'
supports         'almalinux', '~> 9.0'
supports         'debian', '~> 12.0'
