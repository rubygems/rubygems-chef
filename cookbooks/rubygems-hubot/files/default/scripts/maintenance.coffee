# Description:
#   Enable or disable maintenance mode on the load balancer.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot turn on|off maintenance for staging|production
#
# Author:
#   David Radcliffe

exec = require('child_process').exec

runCommand = (cmd, server, callback) ->
  cmd = "ssh #{server} \"#{cmd}\""
  exec cmd, (error, stdout, stderr) ->
    callback(error, stdout, stderr)

getServer = (environment) ->
  return if environment == 'production' then 'lb02.production.rubygems.org' else 'lb01.staging.rubygems.org'

module.exports = (robot) ->

  robot.hear /turn (on|off) maint(enance)?( mode)? for (staging|production)/i, (msg) ->
    if msg.match[1] == 'on'
      command = 'ln -s /etc/nginx/maintenance.html /var/www/rubygems/maintenance.html'
    else if msg.match[1] == 'off'
      command = 'rm /var/www/rubygems/maintenance.html'
    runCommand command, getServer(msg.match[4]), (error, stdout, stderr) ->
      if error
        msg.send error
      else if stderr
        msg.send "Error: #{stderr}"
      else
        msg.send "I have turned #{msg.match[1]} maintenance mode for the #{msg.match[4]} environment!"
