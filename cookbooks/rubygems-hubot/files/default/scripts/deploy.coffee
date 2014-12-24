# Description:
#   Allows hubot to interact with capistrano.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot deploy <env>
#
# Author:
#   Shopify, David Radcliffe

spawn = require("child_process").spawn

exec = (command, args, callback) ->
  data = ""

  options = { env: { HOME: process.env["HOME"], PATH: process.env["PATH"], PWD: '/var/lib/hubot-capistrano/staging' } }
  proc = spawn(command, args, options)

  proc.stdout.on "data", (chunk) ->
    data += chunk

  proc.stderr.on "data", (chunk) ->
    data += chunk

  proc.on "error", (err) ->
    callback "Error: #{err}"

  proc.on "close", (exit_code)->
    if exit_code == 0
      callback data
    else
      callback "Exited with #{exit_code}\n#{data}"

module.exports = (robot) ->
  robot.respond /deploy\s+(production|staging)/i, (msg) ->
    env = msg.match[1]
    msg.send "Deploying to #{env}..."
    cap_command = "cap #{env} deploy"
    server = if env == 'production' then 'bastion02.production.rubygems.org' else 'bastion01.staging.rubygems.org'
    exec "bundle", ["exec", cap_command], (result) ->
      msg.send "```\n#{result}\n```\n"
