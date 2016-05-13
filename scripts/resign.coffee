# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   退職|最終出社|転職 - Reply with 次どこ行くの？

module.exports = (robot) ->
  robot.hear /退職|最終出社|転職/, (msg) ->
    msg.send "次どこ行くの？"

