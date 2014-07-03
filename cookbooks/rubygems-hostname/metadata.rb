name             'rubygems-hostname'
maintainer       'RubyGems.org Ops Team'
license          'MIT'
description      'Set the hostname of RubyGems.org machines using node.name'
version          '0.1.10'

depends 'chef-vault'
depends 'dwradcliffe-dnsimple'
depends 'hostname'

supports 'ubuntu'
