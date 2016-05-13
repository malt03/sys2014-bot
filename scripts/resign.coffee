# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   最終出社 - Reply with 次どこ行くの？

module.exports = (robot) ->
  robot.hear /最終出社/, (msg) ->
    msg.send "次どこ行くの？"

