# Description:
#   hubot show zoi images
#
# Commands:
#   hubot show zoi images when message contain word 'zoi'

zoi = {
    "がんばる":[
        "https://pbs.twimg.com/media/BspTawrCEAAwQnP.jpg:small"
        "https://pbs.twimg.com/media/BspTkipCIAE4a0n.jpg:small"
        "https://pbs.twimg.com/media/BspWSkvCAAAMi43.jpg:small"
        "https://pbs.twimg.com/media/BspWVoqCEAADtZ4.jpg:small"
        "https://pbs.twimg.com/media/BspWaPYCAAAI6Ui.jpg:small"
        "https://pbs.twimg.com/media/BswuTdaCQAAQCkg.jpg:small"
    ]
    "あきらめる":[
        "https://pbs.twimg.com/media/BspWc7LCAAAPzhS.jpg:small"
        "https://pbs.twimg.com/media/BspWfqoCYAE836J.jpg:small"
        "https://pbs.twimg.com/media/BtcSLNRCMAAFGoH.jpg:small"
        "https://pbs.twimg.com/media/BtcSIHmCUAA8Prp.jpg:small"
    ]
    "かえる":[
        "https://pbs.twimg.com/media/BswuLr2CMAA1SpE.jpg:small"
    ]
    "きたく":[
        "https://pbs.twimg.com/media/BtcSRdRCMAArUCS.jpg:small"
    ]
    "ごはんにする":[
        "https://pbs.twimg.com/media/BspWlZFCMAA4fmV.jpg:small"
        "https://pbs.twimg.com/media/BswuMrPCEAEECXg.jpg:small"
        "https://pbs.twimg.com/media/BtcSOp6CcAA9_b4.jpg:small"
        "https://pbs.twimg.com/media/BtcSFKpCQAAb73x.jpg:small"
    ]
    "ねる":[
        "https://pbs.twimg.com/media/BspWoBQCcAAm9y5.jpg:small"
        "https://pbs.twimg.com/media/BtcSM8BCYAE3_8j.jpg:small"
    ]
    "わかった":[
        "https://pbs.twimg.com/media/BswuH1qCcAAueYw.jpg:small"
    ]
    "いけるきがする":[
        "https://pbs.twimg.com/media/BswuNkICcAE4olR.jpg:small"
    ]
    "あせる":[
        "https://pbs.twimg.com/media/BswuJviCYAMCdGc.png:small"
    ]
    "しんちょくだめです":[
        "https://pbs.twimg.com/media/Bsw1StjCQAA9NQ1.jpg:small"
    ]
    "きゅうけいにする":[
        "https://pbs.twimg.com/media/BswuUTPCYAAVX5n.jpg:small"
        "https://pbs.twimg.com/media/BtcSU0xCcAAmz_W.jpg:small"
    ]
    "おはようございまーす":[
        "https://pbs.twimg.com/media/Bs7qd4uCAAAwalT.jpg:small"
        "https://pbs.twimg.com/media/Bts7OpFCcAEkaO4.jpg:small"
    ]
    "つかれた":[
        "https://pbs.twimg.com/media/BtcSG05CMAEEyIG.jpg:small"
    ]
    "ありがとうございます":[
        "https://pbs.twimg.com/media/BtcSDbWCQAADuhK.jpg:small"
    ]
    "やった":[
        "https://pbs.twimg.com/media/Bts7BNsCMAASKsP.jpg:small"
    ]
}

module.exports = (robot) ->
    robot.hear /^(.*?)\s*zoi$/i, (msg) ->
        key = msg.match[1]
        if zoi[key]?
            url = zoi[key][Math.floor(Math.random() * zoi[key].length)]
            msg.send url
        else
            arr = []
            for key, url of zoi
                arr.push(url)
            msg.send arr[Math.floor(Math.random() * arr.length)]

