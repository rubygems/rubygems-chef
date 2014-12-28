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

deploy = (msg, env, branch) ->
  unless allowedToDeploy(msg.message.user.name)
    console.log "#{msg.message.user.name} tried to deploy!"
    msg.send "You are not allowed to deploy! Sorry!"
  else
    deployKey = Math.round(+new Date()/1000)
    url = "https://bot.rubygems.org/deploy/#{deployKey}"
    if branch
      msg.send "Deploying #{branch} branch to #{env}..."
    else
      msg.send "Deploying to #{env}..."

    async.series [
      (callback) ->
        exec "git fetch origin", "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{deployKey}.log", callback
      (callback) ->
        if branch
          exec "git checkout #{branch}", "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{deployKey}.log", callback
        else
          exec "git checkout master", "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{deployKey}.log", callback
      (callback) ->
        exec "bundle check || bundle install --local --without production", "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{deployKey}.log", callback
      (callback) ->
        branchCmd = if branch then "BRANCH=#{branch}" else ''
        cleanCmd = if 'staging' == env then 'deploy:clean_git_cache' else ''
        exec "bundle exec cap #{env} #{cleanCmd} deploy -s user=hubot #{branchCmd}", "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{deployKey}.log", callback
    ], (err, results) ->
      if err
        console.log err
        msg.send ":x: Deploy to #{env} failed! #{url}"
      else
        msg.send ":+1: Deployed to #{env}! #{url}"

module.exports = (robot) ->

  robot.respond /deploy$/i, (msg) ->
    msg.send 'Not quite ready for use yet!'

  robot.respond /deploy\s+(production|staging)$/i, (msg) ->
    env = msg.match[1]
    deploy(msg, env)

  robot.respond /deploy\s(\S+)\sto\sstaging$/i, (msg) ->
    env = 'staging'
    branch = msg.match[1] || 'master'
    deploy(msg, env, branch)

  robot.router.get '/deploy/:key', (req, res) ->
    fs.readFile "#{process.env["HUBOT_DEPLOY_LOG_DIR"]}/#{req.params.key}.log", (err, data) ->
      res.set 'Content-Type', 'text/plain'
      res.send data
