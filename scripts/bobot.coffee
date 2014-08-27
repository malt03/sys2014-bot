# Description:
#   increment and decrement

module.exports = (robot) ->
    robot.hear /(\S+)\+\+/g, (msg) ->
        for match in msg.match
            user = match.replace(/\+\+/, "");
            if not robot.brain.data['bobot']
                robot.brain.data['bobot'] = {}
            if not robot.brain.data['bobot'][user]
                robot.brain.data['bobot'][user] =
                    increment:0
                    decrement:0
            robot.brain.data['bobot'][user]['increment']++
            output_score(robot, msg, user)
        robot.brain.save()

    robot.hear /(\S+)--/g, (msg) ->
        for match in msg.match
            user = match.replace(/--/, "");
            if not robot.brain.data['bobot']
                robot.brain.data['bobot'] = {}
            if not robot.brain.data['bobot'][user]
                robot.brain.data['bobot'][user] =
                    increment:0
                    decrement:0
            robot.brain.data['bobot'][user]['decrement']++
            output_score(robot, msg, user)
        robot.brain.save()

    robot.hear /^ranking$/i, (msg) ->
        ranking = []
        i = 0
        for user, val of robot.brain.data['bobot']
            score = val['increment'] - val['decrement']
            ranking[i++] = {user:user, score:score}
        ranking.sort (a, b) ->
            b['score'] - a['score']
        for n in ranking
            output_score(robot, msg, n['user'])

output_score = (robot, msg, user) ->
    increment = robot.brain.data['bobot'][user]['increment']
    decrement = robot.brain.data['bobot'][user]['decrement']
    score = (increment - decrement)
    msg.send user + ' => '  + score + ' (++:' + increment + ', --:' + decrement + ')'
