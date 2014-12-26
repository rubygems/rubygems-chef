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

spawn = require('child_process').spawn
fs = require('fs')

exec = (command, args, logFile, callback) ->
  data = ""
  fs.appendFile(logFile, command + " " + args.join(" ") + "\n")

  options = { cwd: '/var/lib/hubot-capistrano/staging', env: { HOME: process.env["HOME"], PATH: process.env["PATH"], PWD: '/var/lib/hubot-capistrano/staging' } }
  proc = spawn(command, args, options)

  proc.stdout.on "data", (chunk) ->
    data += chunk
    fs.appendFile(logFile, chunk)

  proc.stderr.on "data", (chunk) ->
    data += chunk
    fs.appendFile(logFile, chunk)

  proc.on "error", (err) ->
    callback "Error: #{err}"

  proc.on "close", (exit_code)->
    if exit_code == 0
      callback null, data
    else
      callback "Exited with #{exit_code}\n#{data}"

allowedToDeploy = (username) ->
  if username == 'dwradcliffe'
    true
  else
    false

module.exports = (robot) ->

  robot.respond /deploy\s+(production|staging)/i, (msg) ->
    unless allowedToDeploy(msg.message.user.name)
      console.log "#{msg.message.user.name} tried to deploy!"
      msg.send "You are not allowed to deploy! Sorry!"
    else
      deployKey = Math.round(+new Date()/1000)
      env = msg.match[1]
      # branch = msg.match[2]
      url = "https://bot.rubygems.org/deploy/#{deployKey}"
      msg.send "Deploying to #{env}... "
      exec "bundle", ["exec", "cap #{env} deploy -s user=hubot"], "/var/log/hubot_deploys/#{deployKey}.log", (err, result) ->
        if err
          msg.send ":x: Deploy to #{env} failed! #{url}"
        else
          msg.send ":+1: Deployed to #{env}! #{url}"

  robot.router.get '/deploy/:key', (req, res) ->
    fs.readFile "/var/log/hubot_deploys/#{req.params.key}.log", (err, data) ->
      res.set 'Content-Type', 'text/plain'
      res.send data
