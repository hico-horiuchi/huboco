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

  loadJSON = ->
    try
      json = fs.readFileSync("./data/thesis.json", 'utf8')
      return props(json)
    catch err
      return false

  deadLineDays = ->
    json = loadJSON()
    unless json
      return false
    str = []
    today = moment()
    for thesis in json.thesis
      days = parseInt((moment(thesis.date, 'YYYY/MM/DD') - today) / 86400000)
      str.push("#{thesis.name}の締切まであと *#{days}* 日")
    return str.join('、 ') + 'です。'

  deadLineDate = ->
    json = loadJSON()
    unless json
      return false
    str = []
    for thesis in json.thesis
      str.push("#{thesis.name}の締切は *#{thesis.date}* ")
    return str.join('、 ') + 'です。'

  robot.respond /thesis$/i, (msg) ->
    str = deadLineDate()
    unless str
      return msg.reply(ERR_MSG)
    msg.reply(str)

  robot.respond /thesis\s+days$/i, (msg) ->
    str = deadLineDays()
    unless str
      return msg.reply(ERR_MSG)
    msg.reply(str)
