# Description:
#   hubot show zoi images
#
# Commands:
#   hubot show zoi images when message contain word 'zoi'
#
#   zoi list:
#       Reply all words that hubot listening.
#
# Usage:
#
# Hubot> がんばるzoi
# Hubot> https://pbs.twimg.com/media/BspWaPYCAAAI6Ui.jpg:small
#
# Hubot> しんちょく zoi
# Hubot> https://pbs.twimg.com/media/Bsw1StjCQAA9NQ1.jpg:small
#
# # zoi add {word} {url}で記憶させられる
# Hubot> zoi add あいうえお some-image-url
# Hubot> あいうえおzoi
# Hubot> some-image-url
#
# # なお、1 wordにつき1 urlのみしか対応づけられない。
#
# zoi remove {word} で記憶を忘れさせられる
# Hubot> zoi remove あいうえお
#
# zoi update {word} { url} で記憶を更新させられる
# Hubot> zoi update あいうえお new-image-url
#
# # キーワードが存在しない or 空白の時はランダム
# Hubot> おやすみなさいzoi
# Hubot> https://pbs.twimg.com/media/BtcSRdRCMAArUCS.jpg:small
#
# Hubot> zoi
# Hubot> https://pbs.twimg.com/media/Bsw1StjCQAA9NQ1.jpg:small
#
# Hubot> zoi list
# Hubot> Shell: がんばる
# Hubot> Shell: あきらめる
# ...
# Hubot> Shell: やった
# Hubot> よし お仕事頑張るぞ!

Crypto = require 'crypto'

module.exports = (robot) ->
    # Zoiのデフォルト値を司るクラス(実質ReadOnly)
    class ZoiDefault
        _DEFAULT =  {
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
            "ごはん":[
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
            "しんちょく":[
                "https://pbs.twimg.com/media/Bsw1StjCQAA9NQ1.jpg:small"
            ]
            "きゅうけい":[
                "https://pbs.twimg.com/media/BswuUTPCYAAVX5n.jpg:small"
                "https://pbs.twimg.com/media/BtcSU0xCcAAmz_W.jpg:small"
            ]
            "おはよう":[
                "https://pbs.twimg.com/media/Bs7qd4uCAAAwalT.jpg:small"
                "https://pbs.twimg.com/media/Bts7OpFCcAEkaO4.jpg:small"
            ]
            "つかれた":[
                "https://pbs.twimg.com/media/BtcSG05CMAEEyIG.jpg:small"
            ]
            "ありがとう":[
                "https://pbs.twimg.com/media/BtcSDbWCQAADuhK.jpg:small"
            ]
            "やった":[
                "https://pbs.twimg.com/media/Bts7BNsCMAASKsP.jpg:small"
            ]
        }

        search:(key) ->
            return [] unless _DEFAULT[key]
            _DEFAULT[key]

        find:(key) ->
            urls = @search(key)
            urls[Math.floor(Math.random() * urls.length)] || null

        keywords: ->
            keywords = []
            for keyword of _DEFAULT
                keywords.push(keyword)
            return keywords

    # Zoiのカスタマイズ部分を司るクラス(redisが絡む部分を押し込める)
    class ZoiCustom
        constructor:(brain) ->
            # TODO: とくに何もしないか例外で死んだほうがいい
            @_brain = if not brain then {} else brain
            unless @_brain.data['zoi']
                @_brain.data['zoi'] = {}
                @_brain.save()

        find:(key) ->
            @_brain.data['zoi'][key] || null

        register:(key, value) ->
            return false unless key
            return false unless value

            @_brain.data['zoi'][key] = value
            @_brain.save()

        delete:(key) ->
            if @find(key)
                delete @_brain.data['zoi'][key]
                @_brain.save()
            else
                false

        keywords: ->
            keywords = []
            for keyword of @_brain.data['zoi']
                keywords.push(keyword)
            return keywords

    # default値とカスタム値を協調させるZoiのMainとなるクラス
    class Zoi
        constructor:(brain) ->
            @_zoi_custom = new ZoiCustom(brain)
            @_zoi_default = new ZoiDefault

        find:(key) ->
            @_zoi_custom.find(key) || @_zoi_default.find(key)

        add:(key, value) ->
            return false if @find(key)
            @_zoi_custom.register(key, value)

        update:(key, value) ->
            if @_zoi_custom.find(key)
                @_zoi_custom.register(key, value)
            else
                false

        delete:(key) ->
            @_zoi_custom.delete(key)

        keywords: ->
            @_zoi_custom.keywords().concat(@_zoi_default.keywords())

        random: ->
            keywords = @keywords()
            random_keyword = keywords[Math.floor(Math.random() * keywords.length)]
            @find(random_keyword)

        only_default: ->
            @_zoi_default

        only_custom: ->
            @_zoi_custom

    robot.hear /^zoi add (.*?)\s(.*?)$/, (msg) ->
        zoi = new Zoi(robot.brain)
        word = msg.match[1]
        image_url = msg.match[2]

        if zoi.add(word, image_url)
            msg.reply "#{word} を登録しました！"
        else if zoi.only_custom().find(word)
            msg.reply "#{word} はもう登録してあります。消したいときは zoi remove キーワード url してください。"
        else
            msg.reply "#{word} はデフォルトで登録されています！　変更したいときはhttps://github.com/malt03/sys2014-bot にプルリクエストしてください。"

    robot.hear /^zoi update (.*?)\s(.*?)$/, (msg) ->
        zoi = new Zoi(robot.brain)
        word = msg.match[1]
        image_url = msg.match[2]

        if zoi.update(word, image_url)
            msg.reply "#{word} の登録を変更しました！"
        else if zoi.only_default().find(word)
            msg.reply "#{word} はデフォルトで登録されています！　変更したいときはhttps://github.com/malt03/sys2014-bot にプルリクエストしてください。"
        else
            msg.reply "#{word} はまだ登録してませんよ？"

    robot.hear /^zoi remove (.*?)$/, (msg) ->
        zoi = new Zoi(robot.brain)
        word = msg.match[1]

        if zoi.delete(word)
            msg.reply "#{word} の登録を消しました！"
        else if zoi.only_default().find(word)
            msg.reply "#{word} はデフォルトで登録されています！　変更したいときはhttps://github.com/malt03/sys2014-bot にプルリクエストしてください。"
        else
            msg.reply "#{word} はまだ登録してませんよ？"

    robot.hear /^zoi list$/i, (msg) ->
        zoi = new Zoi(robot.brain)
        default_keywords = zoi.only_default().keywords()
        description_message = '\nここからはzoi add {word} {url}で追加したzoiです！\n'
        custom_keywords = zoi.only_custom().keywords()
        msg.reply default_keywords.join('\n') + description_message + custom_keywords.join('\n')
        msg.send "よし お仕事頑張るぞ!"

    robot.hear /^zoi list default$/i, (msg) ->
        zoi = new ZoiDefault
        msg.reply zoi.keywords().join('\n')

    robot.hear /^zoi list custom$/i, (msg) ->
        zoi = new ZoiCustom(robot.brain)
        msg.reply zoi.keywords().join('\n')

    robot.hear /^(.*?)\s*zoi$/i, (msg) ->
        zoi = new Zoi(robot.brain)
        word = msg.match[1]
        url = (zoi.find(word) || zoi.random())
        msg.send url
