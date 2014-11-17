# Description:
#   Extra utils
#

module.exports = (robot) ->
    robot.hear /^convunix (\d+)$/i, (msg) ->
        unixtime = msg.match[1]
        if (unixtime <= 8640000000000)
            d = new Date(parseInt(unixtime)*1000)
            body = d.getFullYear() + "/" + (d.getMonth()+1) + "/" + d.getDate() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds()
            msg.send body

