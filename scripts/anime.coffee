# Description:
#   Anime RESTful APIから放送中のアニメの情報を取得
#   (http://api.moemoe.tokyo/anime/v1)
#
# Commands:
#   hubot anime         - 今期放送中のアニメの一覧を表示
#   hubot anime <title> - 今期のアニメをタイトルで検索

moment = require('moment')
table = require('easy-table')

cour = ->
  year = moment().year()
  month = moment().month()
  if month < 3
    return "/#{year}/1"
  if month < 6
    return "/#{year}/2"
  if month < 9
    return "/#{year}/3"
  return "/#{year}/4"

module.exports = (robot) ->
  ERR_MSG = 'Anime RESTful APIの呼出に失敗しました。'
  NIL_MSG = '結果はありません。'

  robot.respond /anime$/i, (msg) ->
    url = "http://api.moemoe.tokyo/anime/v1/master#{cour()}"
    robot.http(url).get() (err, res, body) ->
      unless res.statusCode is 200
        return msg.reply(ERR_MSG)
      animes = JSON.parse(body)
      t = new table
      for anime in animes
        t.cell('Twitter', '@' + anime.twitter_account)
        t.cell('Title', anime.title)
        t.newRow()
      if t.rows.length > 0
        return msg.reply('```\n' + t.print().trim() + '\n```')
      msg.reply(NIL_MSG)

  robot.respond /anime\s+(.+)$/i, (msg) ->
    url = "http://api.moemoe.tokyo/anime/v1/master#{cour()}"
    keyword = msg.match[1]
    robot.http(url).get() (err, res, body) ->
      unless res.statusCode is 200
        return msg.reply(ERR_MSG)
      animes = JSON.parse(body)
      pattern = new RegExp(keyword, 'i')
      t = new table
      for anime in animes
        if anime.title.search(pattern) >= 0
          t.cell('Twitter', '@' + anime.twitter_account)
          t.cell('Title', anime.title)
          t.newRow()
      if t.rows.length > 0
        return msg.reply('```\n' + t.print().trim() + '\n```')
      msg.reply(NIL_MSG)
