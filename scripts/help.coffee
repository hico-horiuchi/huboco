# Description:
#   Hubotのhelpコマンドを生成
#
# Commands:
#   hubot help           - コマンドの一覧を表示
#   hubot help <command> - コマンドの検索結果を表示

table = require('easy-table')

module.exports = (robot) ->
  NIL_MSG = '結果はありません。'

  robot.respond /help\s*(.+)?$/i, (msg) ->
    cmds = robot.helpCommands()
    filter = msg.match[1]
    if filter
      cmds = for cmd in cmds
        continue unless cmd.match(new RegExp(filter, 'i'))
        cmd
      if cmds.length is 0
        return msg.reply(NIL_MSG)
    t = new table
    for cmd in cmds
      cmd = cmd.replace(/^hubot/i, robot.name.toLowerCase())
      arr = cmd.split(' - ')
      t.cell('Command', arr[0])
      t.cell('Description', arr[1])
      t.newRow()
    if t.rows.length > 0
      return msg.reply('```\n' + t.print().trim() + '\n```')
    msg.reply(NIL_MSG)
