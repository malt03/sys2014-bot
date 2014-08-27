# Description:
#   Allows Hubot to Yo Yo Yo !!!
#
# Commands:
#   hubot yo

module.exports = (robot) ->
    robot.hear /^yo$/i, (msg) ->
        yos = [
            "Yo"
            "YO"
            "Yo Yo"
            "Yo Yo Yo"
            "Yo Yo 白くなりゆく山際"
        ]
        msg.send yos[Math.floor(Math.random() * yos.length)]
