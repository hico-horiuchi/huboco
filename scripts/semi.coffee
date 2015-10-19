# Description:
#   ゼミの日時を取得
#
# Commands:
#   hubot semi         - 次のゼミの情報を表示
#   hubot semi list    - 今後1ヶ月のゼミの情報を表示
#   hubot semi changes - 日時が変更になったゼミの一覧を表示

fs = require('fs')
moment = require('moment')
props = require('props')

module.exports = (robot) ->
  ERR_MSG = 'ゼミの日時が設定されていません。'
  NIL_MSG = '結果はありません。'

  loadJSON = ->
    try
      json = fs.readFileSync("./data/semi.json", 'utf8')
      return props(json)
    catch err
      return false

  nextSemi = (day) ->
    date = moment()
    for i in [0..6]
      break if date.day() is day
      date.add(1, 'days')
    return date

  dateFormat = (date, startAt, endAt) ->
    "#{date.locale('ja').format('YYYY/MM/DD(ddd)')} #{startAt}～#{endAt}"

  checkChange = (date, changes) ->
    from = date.format('YYYY/MM/DD')
    for i in changes
      return i.to if i.from is from

  checkRotate = (date, startAt, rotate) ->
    start = moment(startAt, 'YYYY/MM/DD')
    weeks = parseInt((date - start) / 604800000)
    return weeks % rotate

  robot.respond /semi$/i, (msg) ->
    json = loadJSON()
    unless json
      return msg.reply(ERR_MSG)
    date = nextSemi(json.day)
    change = checkChange(date, json.changes)
    rotate = checkRotate(date, json.presen.start_at, json.presen.rotate)
    msg.reply("#{change ? dateFormat(date, json.start_at, json.end_at)} で #{json.presen.users[rotate].join(' さん、')} さんが発表です。")

  robot.respond /semi\s+list$/i, (msg) ->
    json = loadJSON()
    unless json
      return msg.reply(ERR_MSG)
    date = nextSemi(json.day)
    list = []
    for i in [0..3]
      change = checkChange(date, json.changes)
      rotate = checkRotate(date, json.presen.start_at, json.presen.rotate)
      str = "#{change ? dateFormat(date, json.start_at, json.end_at)} (#{json.presen.users[rotate].join(', ')})"
      list.push(str)
      date.add(1, 'weeks')
    msg.reply('```\n' + list.join('\n') + '\n```')

  robot.respond /semi\s+changes$/i, (msg) ->
    json = loadJSON()
    unless json
      return msg.reply(ERR_MSG)
    list = []
    for i in json.changes
      list.push("#{i.from} → #{i.to}")
    if list.length > 0
      msg.reply('```\n' + list.join('\n') + '\n```')
    msg.reply(NIL_MSG)
