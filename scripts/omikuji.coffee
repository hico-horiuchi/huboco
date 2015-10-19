# Description:
#   チャンネルメンバーから1人選んでリプライを送信
#
# Commands:
#   hubot omikuji - チャンネルメンバーから1人選んでリプライを送信

module.exports = (robot) ->
  ERR_MSG = 'Slack APIの呼出に失敗しました。'

  robot.respond /omikuji$/i, (msg) ->
    members = msg.message.rawMessage._client.channels[msg.message.rawMessage.channel].members
    member = members[Math.random() * members.length | 0]
    url = "https://slack.com/api/users.info?token=#{robot.adapter.client.token}&user=#{member}"
    robot.http(url).get()(err, res, body) ->
      unless res.statusCode is 200
        return msg.reply(ERR_MSG)
      json = JSON.parse(body)
      msg.send "@#{json.user.name} さん、よろしくお願いします。"
