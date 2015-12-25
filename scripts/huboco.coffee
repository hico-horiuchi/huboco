# Description:
#   Hubocoの情報などを提供
#
# Commands:
#   hubot hello   - 時刻に応じて簡単な挨拶
#   hubot version - Hubotのバージョンを表示
#   hubot date    - 今日の日付を表示
#   hubot time    - 現在の時刻を表示

moment = require('moment')

module.exports = (robot) ->
  robot.respond /hello$/i, (msg) ->
    hour = new Date().getHours()
    if 6 <= hour < 12
      return msg.reply('おはようございます。')
    if 12 <= hour < 18
      return msg.reply('こんにちは。')
    if 18 <= hour < 24
      return msg.reply('こんばんは。')
    msg.reply('おやすみなさい。')

  robot.respond /version$/i, (msg) ->
    msg.reply("多分、私は *#{robot.version}* 人目だと思うから。")

  robot.respond /date$/i, (msg) ->
    msg.reply("*#{moment().locale('ja').format('YYYY/MM/DD(ddd)')}* です。")

  robot.respond /time$/i, (msg) ->
    msg.reply("*#{moment().format('HH:mm:ss')}* です。")
