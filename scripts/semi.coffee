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
table = require('easy-table')

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
      if date.day() is day
        break
      date.add(1, 'days')
    return date

  dateFormat = (date, startAt, endAt) ->
    "#{date.locale('ja').format('YYYY/MM/DD(ddd)')} #{startAt}～#{endAt}"

  checkChange = (date, changes) ->
    from = date.format('YYYY/MM/DD')
    for i in changes
      if i.from is from
        return i.to

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
    msg.reply("*#{change ? dateFormat(date, json.start_at, json.end_at)}* で #{json.presen.users[rotate].join(' さん、')} さんが発表です。")

  robot.respond /semi\s+list$/i, (msg) ->
    json = loadJSON()
    unless json
      return msg.reply(ERR_MSG)
    date = nextSemi(json.day)
    t = new table
    for i in [0..3]
      change = checkChange(date, json.changes)
      rotate = checkRotate(date, json.presen.start_at, json.presen.rotate)
      t.cell('Date', change ? dateFormat(date, json.start_at, json.end_at))
      t.cell('Presenter', json.presen.users[rotate].join(', '))
      t.newRow()
      date.add(1, 'weeks')
    msg.reply('```\n' + t.print().trim() + '\n```')

  robot.respond /semi\s+changes$/i, (msg) ->
    json = loadJSON()
    unless json
      return msg.reply(ERR_MSG)
    t = new table
    for i in json.changes
      t.cell('From', i.from)
      t.cell('To', '→ ' +i.to )
      t.newRow()
    if t.rows.length > 0
      msg.reply('```\n' + t.print().trim() + '\n```')
    msg.reply(NIL_MSG)
