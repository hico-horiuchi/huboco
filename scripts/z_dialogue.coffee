# Description
#   どのコマンドにも一致しない場合に雑談
#
# Configuration:
#   HUBOT_DOCOMO_DIALOGUE_API_KEY
#
# Notes:
#   会話の継続。context, mode を保存。ただし3分経過したら破棄。

module.exports = (robot) ->
  ERR_MSG = 'docomo 雑談対話APIの呼出に失敗しました。'
  API_KEY = process.env.HUBOT_DOCOMO_DIALOGUE_API_KEY

  status = { place: '香川' }

  cmds = []
  for help in robot.helpCommands()
    cmd = help.split(' ')[1]
    cmds.push(cmd) if cmds.indexOf(cmd) is -1

  robot.respond /(.+)$/i, (msg) ->
    unless API_KEY?
      return
    cmd = msg.match[1].split(' ')[0]
    unless cmds.indexOf(cmd) is -1
      return
    status.nickname = msg.envelope.user.name
    status.utt = msg.match[1]
    now = new Date().getTime()
    if now - status.time > 3 * 60 * 1000
      status.context = ''
      status.mode = ''
    msg
      .http('https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue')
      .query(APIKEY: API_KEY)
      .header('Content-Type', 'application/json')
      .post(JSON.stringify(status)) (err, res, body) ->
        if err? or res.statusCode isnt 200
          return msg.reply("#{ERR_MSG}\n```\n#{err}\n```")
        msg.reply(JSON.parse(body).utt)
        status.time = now
        status.context = JSON.parse(body).context
        status.mode = JSON.parse(body).mode
