# Description:
#   卒業論文・修士論文の締切を表示
#
# Commands:
#   hubot thesis      - 論文締切の日付を表示
#   hubot thesis days - 論文締切までの日数を表示

fs = require('fs')
moment = require('moment')
props = require('props')

module.exports = (robot) ->
  ERR_MSG = '論文の締切が設定されていません。'
  THESIS = ['bachelor', 'master']
  THESIS_JP = { bachelor: '卒論', master: '修論' }

  loadJSON = () ->
    try
      json = fs.readFileSync("./data/thesis.json", 'utf8')
      return props(json)
    catch err
      return false

  deadLineDays = (room) ->
    json = loadJSON()
    return false unless json
    str = []
    today = moment()
    for key in THESIS
      date = json[key]
      if date
        days = parseInt((moment(date, 'YYYY/MM/DD') - today) / 86400000)
        str.push("#{THESIS_JP[key]}の締切まで #{days} 日")
    return str.join('、') + 'です。'

  deadLineDate = (room) ->
    json = loadJSON(room)
    return false unless json
    str = []
    for key in THESIS
      date = json[key]
      if date
        str.push("#{THESIS_JP[key]}の締切は #{date} ")
    return str.join('、') + 'です。'

  robot.respond /thesis$/i, (msg) ->
    str = deadLineDate(msg.message.room)
    msg.reply(str) if str
    msg.reply(ERR_MSG) unless str

  robot.respond /thesis\s+days$/i, (msg) ->
    str = deadLineDays(msg.message.room)
    msg.reply(str) if str
    msg.reply(ERR_MSG) unless str
