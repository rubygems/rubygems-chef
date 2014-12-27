# Description:
#   Allows hubot to interact with capistrano.
#
# Dependencies:
#   * async
#
# Configuration:
#   None
#
# Commands:
#   hubot deploy <env>
#
# Author:
#   David Radcliffe

child_process = require 'child_process'
fs = require 'fs'
async = require 'async'

exec = (command, logFile, callback) ->
  fs.appendFile(logFile, command + "\n")

  options = { cwd: process.env["HUBOT_DEPLOY_DIR"], env: { HOME: process.env["HOME"], PATH: process.env["PATH"], PWD: process.env["HUBOT_DEPLOY_DIR"] } }
  proc = child_process.exec(command, options)

  proc.stdout.on "data", (chunk) ->
    fs.appendFile(logFile, chunk)

  proc.stderr.on "data", (chunk) ->
    fs.appendFile(logFile, chunk)

  proc.on "error", (err) ->
    callback "Error: #{err}"

  proc.on "close", (exit_code)->
    if exit_code == 0
      callback null
    else
      callback "Exited with #{exit_code}"

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

      async.series [
        (callback) ->
          exec "bundle check || bundle install --local --without production", "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{deployKey}.log", callback
        (callback) ->
          exec "bundle exec cap #{env} deploy -s user=hubot", "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{deployKey}.log", callback
      ], (err, results) ->
        if err
          msg.send ":x: Deploy to #{env} failed! #{url}"
        else
          msg.send ":+1: Deployed to #{env}! #{url}"

  robot.router.get '/deploy/:key', (req, res) ->
    fs.readFile "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{req.params.key}.log", (err, data) ->
      res.set 'Content-Type', 'text/plain'
      res.send data
