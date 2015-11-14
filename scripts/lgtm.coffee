# Description:
#   Imgur の HUBOT_IMGUR_ALBUM_ID からLGTM画像を送信
#
# Configuration:
#   HUBOT_IMGUR_ALBUM_ID
#   HUBOT_IMGUR_CLIENT_ID
#   HUBOT_GITHUB_ACCESS_TOKEN
#
# Commands:
#   hubot lgtm                    - Imgur の HUBOT_IMGUR_ALBUM_ID からLGTM画像を送信
#   hubot lgtm <user>/<repo> <id> - リポジトリのIssueまたはPull RequestにLGTM画像をコメント

fs = require('fs')
props = require('props')
githubAPI = require('node-github')

module.exports = (robot) ->
  ERR_MSG = 'APIの呼出に失敗しました。'
  NIL_MSG = '画像がアップロードされていません。'

  getAccountImages = (msg, args) ->
    msg
      .http("https://api.imgur.com/3/album/#{process.env.HUBOT_IMGUR_ALBUM_ID}/images")
      .header('Authorization', "Client-ID #{process.env.HUBOT_IMGUR_CLIENT_ID}")
      .get() (err, res, body) ->
        if err?
          return msg.reply("Imgur #{ERR_MSG}\n```\n#{err}\n```")
        images = JSON.parse(body).data
        if images.length is 0
          return msg.reply(NIL_MSG)
        args['image'] = images[Math.random() * images.length | 0]
        return args['callbacks'].shift()(msg, args)

  sendLGTM = (msg, args) ->
    msg.send(args['image'].link)

  issuesCreateComment = (msg, args) ->
    github = new githubAPI({
      version: '3.0.0'
    })
    github.authenticate({
      type: 'oauth'
      token: process.env.HUBOT_GITHUB_ACCESS_TOKEN
    })
    github.issues.createComment({
      user: args['user']
      repo: args['repo']
      number: Number(args['id'])
      body: "![#{args['image'].id}](#{args['image'].link})\nFrom [#{robot.name}](http://#{robot.name}.hiconyan.com/#{robot.name}/info) by #{msg.message.user.name}."
    }, (err, res) ->
      if err?
        return msg.reply("GitHub #{ERR_MSG}\n```\n#{err}\n```")
    )

  robot.respond /lgtm$/i, (msg) ->
    getAccountImages(msg, {
      callbacks: [sendLGTM]
    })

  robot.respond /lgtm\s+(\S+)\/(\S+)\s+([0-9]+)$/i, (msg) ->
    getAccountImages(msg, {
      callbacks: [issuesCreateComment]
      user: msg.match[1]
      repo: msg.match[2]
      id: msg.match[3]
    })
