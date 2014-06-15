# disable these options to keep duo's use of ForceCommand secure
node.default['openssh']['server']['permit_tunnel'] = "no"
node.default['openssh']['server']['allow_tcp_forwarding'] = "no"

include_recipe "openssh"
