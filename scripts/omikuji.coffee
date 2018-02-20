# Description:
#   チャンネルメンバーから1人選んでリプライを送信
#
# Commands:
#   hubot omikuji - チャンネルメンバーから1人選んでリプライを送信

module.exports = (robot) ->
  ERR_MSG = 'Slack APIの呼出に失敗しました。'

  robot.respond /omikuji$/i, (msg) ->
    members = msg.message.rawMessage.channel.members
    member = members[Math.random() * members.length | 0]
    url = "https://slack.com/api/users.info?token=#{robot.adapter.client.rtm._token}&user=#{member}"
    msg.http(url).get() (err, res, body) ->
      if err? or res.statusCode isnt 200
        return msg.reply("#{ERR_MSG}\n```\n#{err}\n```")
      json = JSON.parse(body)
      msg.send "@#{json.user.name} さん、よろしくお願いします。"
