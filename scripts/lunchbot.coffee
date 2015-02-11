# Description:
#   hubot recommend restaurant for lunch around Shibuya
#
# Commands:
#   lunch
#       Select from default list (Shibuya lunch passport vol.3)
#
#   lunch passport3
#       Select from Shibuya lunch passport vol.3
#
#   If you want another list, please add json file in "data/lunchbot/" and send pull request.
#
util = require('util')
querystring = require('querystring')
passport3List = require('../data/lunchbot/passport_ver3.json')

defaultListName = 'passport3'
fromPlace = '渋谷ヒカリエ'
lunch = {'passport3': passport3List}

getGoogleMapUrl = (name) ->
    encodedName = querystring.escape('渋谷 ' + name)
    url = "https://www.google.co.jp/maps/dir/#{fromPlace}/#{encodedName}"

module.exports = (robot) ->
    robot.hear /^lunch\s?(.*?)$/, (msg) ->
        listName = msg.match[1] || defaultListName
        list = lunch[listName]
        unless list
            msg.reply "#{listName}のリストは存在しないようです。リストの追加はプルリクしてね！"
            return

        restaurant = list[Math.floor(Math.random() * list.length)]
        msg.reply "今日のランチは #{restaurant.name} p#{restaurant.page}でどうですか？"
        msg.reply getGoogleMapUrl(restaurant.name)
