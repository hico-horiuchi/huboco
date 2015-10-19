# Description:
#   ゼミの前日10時に通知、発表者にはリプライ

cronJob = require('cron').CronJob
fs = require('fs')
moment = require('moment')
props = require('props')

module.exports = (robot) ->
  ROOM = 'member'
  NTF_MSG = '明日はゼミです。'

  say = (room, message) ->
    robot.send({ room: room }, message)

  loadJSON = ->
    json = fs.readFileSync("./data/semi.json", 'utf8')
    return props(json)

  nextSemi = (day) ->
    date = moment()
    for i in [0..6]
      break if date.day() is day
      date.add(1, 'days')
    return date

  checkChange = (date, changes) ->
    from = date.format('YYYY/MM/DD')
    for i in changes
      if i.from is from
        result = i.to.match(/([0-9]+)\/([0-9]+)\/([0-9]+)/)
        return result[1] + result[2] + result[3]

  checkRotate = (date, startAt, rotate) ->
    start = moment(startAt, 'YYYY/MM/DD')
    weeks = parseInt((date - start) / 604800000)
    return weeks % rotate

  semiCron = new cronJob({
    cronTime: '0 0 10 * * *'
    onTick: ->
      json = loadJSON()
      date = nextSemi(json.day)
      change = checkChange(date, json.changes)
      next = change ? date.format('YYYYMMDD')
      tomorrow = moment().add(1, 'days').format('YYYYMMDD')
      if next is tomorrow
        rotate = checkRotate(date, json.presen.start_at, json.presen.rotate)
        str = "#{NTF_MSG}\n#{json.presen.account[rotate].join(' さん、')} さんが発表です。"
        say(ROOM, str)
    start: true
    timeZone: 'Asia/Tokyo'
  })
