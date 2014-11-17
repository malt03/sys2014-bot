# Description:
#   Extra utils
#

module.exports = (robot) ->
    robot.hear /^convunix (.*)$/i, (msg) ->
        unixtime = msg.match[1]
        d = new Date(parseInt(unixtime) )
        body = d.getFullYear() + "/" + d.getMonth() + "/" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds()
        msg.send body

