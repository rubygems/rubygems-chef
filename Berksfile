source 'https://supermarket.getchef.com'

# IMPORTANT: this section of the Berksfile is solely for installing wrapper
# cookbooks and uploading them to hosted chef. All dependencies which are
# not prefixed with 'rubygems' should be put in the Berksfile included in each
# role or base cookbook.

cookbook 'rubygems', path: 'cookbooks/rubygems'
cookbook 'rubygems-app', path: 'cookbooks/rubygems-app'
cookbook 'rubygems-apt', path: 'cookbooks/rubygems-apt'
cookbook 'rubygems-backups', path: 'cookbooks/rubygems-backups'
cookbook 'rubygems-balancer', path: 'cookbooks/rubygems-balancer'
cookbook 'rubygems-bastion', path: 'cookbooks/rubygems-bastion'
cookbook 'rubygems-cache', path: 'cookbooks/rubygems-cache'
cookbook 'rubygems-chef', path: 'cookbooks/rubygems-chef'
cookbook 'rubygems-ci', path: 'cookbooks/rubygems-ci'
cookbook 'rubygems-cloud-init', path: 'cookbooks/rubygems-cloud-init'
cookbook 'rubygems-database', path: 'cookbooks/rubygems-database'
cookbook 'rubygems-fail2ban', path: 'cookbooks/rubygems-fail2ban'
cookbook 'rubygems-hostname', path: 'cookbooks/rubygems-hostname'
cookbook 'rubygems-hosts', path: 'cookbooks/rubygems-hosts'
cookbook 'rubygems-logging', path: 'cookbooks/rubygems-logging'
cookbook 'rubygems-metrics', path: 'cookbooks/rubygems-metrics'
cookbook 'rubygems-monitoring', path: 'cookbooks/rubygems-monitoring'
cookbook 'rubygems-motd', path: 'cookbooks/rubygems-motd'
cookbook 'rubygems-ntp', path: 'cookbooks/rubygems-ntp'
cookbook 'rubygems-people', path: 'cookbooks/rubygems-people'
cookbook 'rubygems-redis', path: 'cookbooks/rubygems-redis'
cookbook 'rubygems-repo', path: 'cookbooks/rubygems-repo'
cookbook 'rubygems-ruby', path: 'cookbooks/rubygems-ruby'
cookbook 'rubygems-sensu', path: 'cookbooks/rubygems-sensu'
cookbook 'rubygems-ssh', path: 'cookbooks/rubygems-ssh'
cookbook 'rubygems-utility', path: 'cookbooks/rubygems-utility'

# Add cookbooks which diverge from the versions available on the community
# site.
cookbook 'aptly', git: 'git@github.com:skottler/aptly.git', ref: 'fix_seed'
cookbook 'bprobe', git: 'git@github.com:boundary/bprobe_cookbook.git'
cookbook 'collectd_plugins', git: 'git@github.com:skottler/chef-collectd_plugins.git'
cookbook 'collectd', git: 'git@github.com:librato/collectd-cookbook.git'
cookbook 'collectd-librato', git: 'git@github.com:librato/collectd-librato-cookbook.git'
cookbook 'dnsimple', path: 'cookbooks/dnsimple'
cookbook 'duo-security', git: 'git@github.com:skottler/chef-duo-security'
