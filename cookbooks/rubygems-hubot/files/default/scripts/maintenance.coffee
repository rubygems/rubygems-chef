# Description:
#   Enable or disable maintenance mode on the load balancer.
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   hubot turn on|off maintenance for staging|production
#
# Author:
#   David Radcliffe

module.exports = (robot) ->

  robot.hear /turn (on|off) maintenance( mode)? for (staging|production)/i, (msg) ->
    msg.send "I have turned #{msg.match[1]} maintenance mode for the #{msg.match[3]} environment!"
