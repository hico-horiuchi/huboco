# Description:
#   data/crontab.jsonの定時処理を実行
#
# Commands:
#   hubot crontab - チャンネルに設定されたcronを表示

cronJob = require('cron').CronJob
fs = require('fs')
props = require('props')
table = require('easy-table')

class Job
  constructor: (room, pattern, message, robot) ->
    @room = room
    @pattern = pattern
    @message = message
    @cronjob = new cronJob({
      cronTime: @pattern
      onTick: => @say(robot)
      start: false
      timeZone: 'Asia/Tokyo'
    })
    @cronjob.start()
  say: (robot) ->
    robot.send({ room: @room }, @message)

module.exports = (robot) ->
  ERR_MSG = 'crontabファイルが設置されていません。'
  NIL_MSG = '結果はありません。'

  loadJSON = ->
    try
      json = fs.readFileSync('./data/crontab.json', 'utf8')
      return props(json)
    catch err
      return false

  json = loadJSON()
  jobs = []
  for cron, i in json.crontab
    room = cron[0].replace(/^#/, '')
    job = new Job(room, cron[1], cron[2], robot)
    jobs.push(job)

  robot.respond /crontab$/i, (msg) ->
    json = loadJSON()
    unless json
      return msg.reply(ERR_MSG)
    room = String(msg.message.room)
    t = new table
    for job in jobs
      if job.room is room
        t.cell('Pattern', job.pattern)
        t.cell('Message', job.message.replace('\n', ' '))
        t.newRow()
    if t.rows.length > 0
      return msg.reply('\n```\n' + t.print().trim() + '\n```')
    msg.reply(NIL_MSG)
