name             'osl-git'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 12.18' if respond_to?(:chef_version)
issues_url       'https://github.com/osuosl-cookbooks/osl-git/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-git'
description      'Installs/Configures osl-git'
long_description 'Installs/Configures osl-git'
version          '1.0.1'

depends          'git'

supports         'centos', '~> 7.0'
