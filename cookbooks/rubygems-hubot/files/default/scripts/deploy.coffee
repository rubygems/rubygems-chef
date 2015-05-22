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

module.exports = (robot) ->

  robot.respond /deploy/i, (msg) ->
    msg.send 'Please use https://shipit.rubygems.org to deploy.'
