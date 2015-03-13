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

spawn = require("child_process").spawn

exec = (command, args, callback) ->
  data = ""

  options = { env: { HOME: process.env["HOME"], PATH: process.env["PATH"], PWD: process.env["PWD"] } }
  proc = spawn(command, args, options)

  proc.stdout.on "data", (chunk) ->
    data += chunk

  proc.stderr.on "data", (chunk) ->
    data += chunk

  proc.on "error", (err) ->
    callback "Error: #{err}"

  proc.on "close", (exit_code)->
    if exit_code == 0
      callback null, data
    else
      callback "Exited with #{exit_code}:\n#{data}"

getServer = (environment) ->
  return if environment == 'production' then 'lb03.production.rubygems.org' else 'lb01.staging.rubygems.org'

module.exports = (robot) ->

  robot.hear /turn (on|off) maint(enance)?( mode)? for (staging|production)/i, (msg) ->
    if msg.match[1] == 'on'
      command = 'sudo ln -s /etc/nginx/maintenance.html /var/www/rubygems/maintenance.html'
    else if msg.match[1] == 'off'
      command = 'sudo rm /var/www/rubygems/maintenance.html'
    server = getServer(msg.match[4])
    exec "ssh", ["hubot@#{server}", command], (err, result) ->
      if err
        msg.send "```\n#{err}\n```\n"
      else
        msg.send ":+1: I have turned #{msg.match[1]} maintenance mode for the #{msg.match[4]} environment!"
