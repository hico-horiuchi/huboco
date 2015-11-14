# Description:
#   リポジトリのIssueまたはPull Requestの情報を表示
#
# Configuration:
#   HUBOT_GITHUB_ACCESS_TOKEN
#
# Commands:
#   hubot gh <user>/<repo> <id> - リポジトリのIssueまたはPull Requestの情報を表示

githubAPI = require('node-github')
moment = require('moment')

module.exports = (robot) ->
  ERR_MSG = 'GitHub APIの呼出に失敗しました。'

  stateColor = {
    open: '#6cc644'
    closed: '#bd2c00'
    merged: '#6e5494'
  }

  setAttachment = (issue) ->
      attachment = {
        fallback: "##{issue.number}: #{issue.title}"
        title: "##{issue.number}: #{issue.title}"
        title_link: issue.html_url
        author_name: issue.user.login
        author_link: issue.user.html_url
        author_icon: issue.user.avatar_url
        text: issue.body.replace(/!\[.+\]\(.+\)/, '').replace(/\[(.+)\]\((.+)\)/, '<$2|$1>')
        color: stateColor[issue.state]
        fields: [{
          title: 'Updated at'
          value: moment(issue.updated_at).locale('ja').format('YYYY/MM/DD hh:mm')
          short: true
        }]
        mrkdwn_in: ['text']
      }
      if issue.assignee
        attachment.fields.push({
          title: 'Assignee'
          value: "<#{issue.assignee.html_url}|#{issue.assignee.login}>"
          short: true
        })
      images = issue.body.match(/!\[.+\]\((.+)\)/)
      attachment.image_url = images[1] if images
      return attachment

  issuesGetRepoIssue = (msg, args) ->
    github = new githubAPI({
      version: '3.0.0'
    })
    github.authenticate({
      type: 'oauth'
      token: process.env.HUBOT_GITHUB_ACCESS_TOKEN
    })
    github.issues.getRepoIssue({
      user: args['user']
      repo: args['repo']
      number: Number(args['id'])
    }, (err, res) ->
      if err?
        return msg.reply("#{ERR_MSG}\n```\n#{err}\n```")
      robot.emit('slack-attachment', {
        message: msg.message
        attachments: setAttachment(res)
      })
    )

  robot.respond /gh\s+(\S+)\/(\S+)\s+([0-9]+)$/i, (msg) ->
    issuesGetRepoIssue(msg, {
      user: msg.match[1]
      repo: msg.match[2]
      id: msg.match[3]
    })
