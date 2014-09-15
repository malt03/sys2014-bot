# Description:
#   A way to know weather all over the world.
#
# Commands:
#   hubot weather <query>

DEFAULT = '渋谷'
CNT = 3
ERROR = '読み込み失敗'

module.exports = (robot) ->
  robot.respond /weather\s*(.*)?/i, (msg) ->
    getGeographicInfo msg, msg.match[1]

getGeographicInfo = (msg, query) ->
  query = DEFAULT if not query?
  msg.http('http://maps.googleapis.com/maps/api/geocode/json')
    .query(address: query)
    .get() (err, res, body) ->
      try
        body = JSON.parse(body)
        address = body.results[0].formatted_address
        location = body.results[0].geometry.location
        lat = location.lat
        lng = location.lng
      catch err
        msg.send ERROR
        return
      getWeatherInfo msg, query, address, lat, lng

getWeatherInfo = (msg, query, address, lat, lng) ->
  cnt = CNT
  msg.http('http://api.openweathermap.org/data/2.5/forecast/daily')
    .query(lat: lat, lon: lng, cnt: cnt, mode: 'json')
    .get() (err, res, body) ->
      try
        body = JSON.parse(body)
        text = "#{query}（#{address}）の天気\n"
        for i in [0..cnt-1]
          date = formatDate body.list[i].dt
          weather = body.list[i].weather[0].description
          weather = translation[weather] if translation[weather]?
          maxCelsius = convertToCelsius body.list[i].temp.max
          minCelsius = convertToCelsius body.list[i].temp.min
          text += date + ' : '
          text += weather + '  '
          text += maxCelsius + '°C / '
          text += minCelsius + "°C \n"
      catch err
        msg.send ERROR
        return
      msg.send "#{text}"

convertToCelsius = (kelvin) ->
  celsius = kelvin - 273.15
  celsius.toFixed(0)

formatDate = (unixtime) ->
  d = new Date(unixtime * 1000)
  month = d.getMonth() + 1
  date  = d.getDate()
  if date != getCurrentDate()
    "#{month}月#{date}日 "
  else
    "#{month}月#{date}日*"

getCurrentDate = () ->
  d = new Date()
  date = d.getDate()

translation =
  'thunderstorm with light rain'    : '雷雨'
  'thunderstorm with rain'          : '雷雨'
  'thunderstorm with heavy rain'    : '雷雨'
  'light thunderstorm'              : '弱い雷雨'
  'thunderstorm'                    : '雷雨'
  'heavy thunderstorm'              : '激しい雷雨'
  'ragged thunderstorm'             : '雷雨'
  'thunderstorm with light drizzle' : '雷雨'
  'thunderstorm with drizzle'       : '雷雨'
  'thunderstorm with heavy drizzle' : '雷雨'
  'light intensity drizzle'         : '弱い霧雨'
  'drizzle'                         : '霧雨'
  'heavy intensity drizzle'         : '強い霧雨'
  'light intensity drizzle rain'    : '弱い霧雨'
  'drizzle rain'                    : '霧雨'
  'heavy intensity drizzle rain'    : '強い霧雨'
  'shower rain and drizzle'         : 'にわか雨'
  'heavy shower rain and drizzle'   : '激しいにわか雨'
  'shower drizzle'                  : '急な霧雨'
  'light rain'                      : '小雨'
  'moderate rain'                   : '雨'
  'heavy intensity rain'            : '大雨'
  'very heavy rain'                 : '非常に激しい雨'
  'extreme rain'                    : '豪雨'
  'freezing rain'                   : '冷たい雨'
  'light intensity shower rain'     : '弱いにわか雨'
  'shower rain'                     : 'にわか雨'
  'heavy intensity shower rain'     : '強いにわか雨'
  'ragged shower rain'              : 'にわか雨'
  'light snow'                      : '小雪'
  'snow'                            : '雪'
  'heavy snow'                      : '大雪'
  'sleet'                           : 'みぞれ'
  'shower sleet'                    : '急なみぞれ'
  'light rain and snow'             : '小雨と雪'
  'rain and snow'                   : '雨と雪'
  'light shower snow'               : '急な小雪'
  'shower snow'                     : '急な雪'
  'heavy shower snow'               : '急な豪雪'
  'mist'                            : '霞'
  'smoke'                           : '霧'
  'haze'                            : 'もや'
  'Sand/Dust Whirls'                : '砂/ほこり旋風'
  'Fog'                             : '霧'
  'sand'                            : '砂'
  'dust'                            : 'ほこり'
  'VOLCANIC ASH'                    : '火山灰'
  'SQUALLS'                         : 'スコール'
  'TORNADO'                         : '竜巻'
  'sky is clear'                    : '快晴'
  'few clouds'                      : '晴れ'
  'scattered clouds'                : '晴れ'
  'broken clouds'                   : '晴れ'
  'overcast clouds'                 : '曇り'
  'tornado'                         : '竜巻'
  'tropical storm'                  : '熱帯暴風雨'
  'hurricane'                       : 'ハリケーン'
  'cold'                            : '寒い'
  'hot'                             : '暑い'
  'windy'                           : '風のある天気'
  'hail'                            : '雹'
  'Calm'                            : '穏やかな天気'
  'Light breeze'                    : '弱い風'
  'Gentle Breeze'                   : 'そよ風'
  'Moderate breeze'                 : '風'
  'Fresh Breeze'                    : '疾風'
  'Strong breeze'                   : '強風'
  'High wind, near gale'            : '強風'
  'Gale'                            : '強風'
  'Severe Gale'                     : '強烈な風'
  'Storm'                           : '嵐'
  'Violent Storm'                   : '激しい嵐'
  'Hurricane'                       : 'ハリケーン'
