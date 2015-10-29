# Description:
#   Slackのユーザー招待機能を提供
#
# Configuration:
#   HUBOT_SLACK_ADMIN_TOKEN
#
# URLs:
#   GET  /slack/form   - Slackのチームの招待フォームを表示
#   POST /slack/invite - Slackのチームにユーザーを招待

querystring = require('querystring')
request = require('request')
urler = require('url')

module.exports = (robot) ->
  ROOM = 'member'

  formPage = (name) ->
    """
<!DOCTYPE html>
<html>
  <head>
    <title>Slack Form | Huboco</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport" />
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/bootswatch/3.3.5/lumen/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" />
    <link href="//fonts.googleapis.com/css?family=Exo:400,600" rel="stylesheet" />
    <link href="//raw.githubusercontent.com/hico-horiuchi/huboco/master/data/favicon.ico" rel="shortcut icon" />
    <style type="text/css"><!--
      body, h1, h2, h3, h4, text {
        font-family: 'Exo', sans-serif;
        font-weight: 400;
      }
      .bold { font-weight: 600; }
      .main {
        text-align: center;
        margin: 50px 0;
      }
      a.black { color: #333333; }
      a.black:hover {
        color: #999999;
        text-decoration: none;
      }
      @media screen and (max-width: 970px) {
        .main { margin: 15px 0; }
      }
    --></style>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4 main">
          <div class="well">
            <img src="https://assets.brandfolder.com/c8d4sd15/original/slack_rgb.png" width="256" />
            <p>チーム「#{name}」に招待します。</p>
            <form action="/slack/invite" method="post">
              <input type="hidden" name="name" value="#{name}">
              <div class="form-group">
                <div class="input-group">
                  <span class="input-group-addon"><i class="fa fa-envelope fa-fw"></i></span>
                  <input type="text" class="form-control" name="email" placeholder="メールアドレス">
                  <span class="input-group-btn">
                    <button class="btn btn-default" type="submit">送信</button>
                  </span>
                </div>
              </div>
            </form>
            <p>&copy; <a class="black" href="http://hico-horiuchi.github.io/" target="_blank">Akihiko Horiuchi</a></p>
          </div>
        </div>
        <div class="col-md-4"></div>
      </div>
    </div>
  </body>
</html>
    """

  submitPage = (name, email) ->
    """
<!DOCTYPE html>
<html>
  <head>
    <title>Slack Invite | Huboco</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport" />
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/bootswatch/3.3.5/lumen/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" />
    <link href="//fonts.googleapis.com/css?family=Exo:400,600" rel="stylesheet" />
    <link href="//raw.githubusercontent.com/hico-horiuchi/huboco/master/data/favicon.ico" rel="shortcut icon" />
    <style type="text/css"><!--
      body, h1, h2, h3, h4, text {
        font-family: 'Exo', sans-serif;
        font-weight: 400;
      }
      .bold { font-weight: 600; }
      .main {
        text-align: center;
        margin: 50px 0;
      }
      a.black { color: #333333; }
      a.black:hover {
        color: #999999;
        text-decoration: none;
      }
      .panel { margin-bottom: 15px; }
      .panel-body { padding: 10px; }
      .panel-heading {
        padding: 10px;
        color: #fff;
        background-color: #3b434b;
      }
      @media screen and (max-width: 970px) {
        .main { margin: 15px 0; }
      }
    --></style>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4 main">
          <div class="well">
            <img src="https://assets.brandfolder.com/c8d4sd15/original/slack_rgb.png" width="256" />
            <p>チーム「#{name}」に招待しました。</p>
            <div class="panel">
              <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-envelope"></i></h3>
              </div>
              <div class="panel-body">
                #{email}
              </div>
            </div>
            <p>&copy; <a class="black" href="http://hico-horiuchi.github.io/" target="_blank">Akihiko Horiuchi</a></p>
          </div>
        </div>
        <div class="col-md-4"></div>
      </div>
    </div>
  </body>
</html>
    """

  errorPage = (error) ->
    """
<!DOCTYPE html>
<html>
  <head>
    <title>Slack Error | Huboco</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta content="width=device-width, initial-scale=1" name="viewport" />
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/bootswatch/3.3.5/lumen/bootstrap.min.css" rel="stylesheet" />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" />
    <link href="//fonts.googleapis.com/css?family=Exo:400,600" rel="stylesheet" />
    <link href="//raw.githubusercontent.com/hico-horiuchi/huboco/master/data/favicon.ico" rel="shortcut icon" />
    <style type="text/css"><!--
      body, h1, h2, h3, h4, text {
        font-family: 'Exo', sans-serif;
        font-weight: 400;
      }
      .bold { font-weight: 600; }
      .main {
        text-align: center;
        margin: 50px 0;
      }
      a.black { color: #333333; }
      a.black:hover {
        color: #999999;
        text-decoration: none;
      }
      .alert {
        margin-bottom: 15px;
        padding: 10px;
        color: #fff;
        background-color: #3b434b;
      }
      @media screen and (max-width: 970px) {
        .main { margin: 15px 0; }
      }
    --></style>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4 main">
          <div class="well">
            <img src="https://assets.brandfolder.com/c8d4sd15/original/slack_rgb.png" width="256" />
            <p>エラーが発生しました。</p>
            <div class="alert">
              <strong>#{error}</strong>
            </div>
            <p>&copy; <a class="black" href="http://hico-horiuchi.github.io/" target="_blank">Akihiko Horiuchi</a></p>
          </div>
        </div>
        <div class="col-md-4"></div>
      </div>
    </div>
  </body>
</html>
    """

  robot.router.get '/slack/form', (req, call) ->
    options = {
      url: 'https://slack.com/api/team.info'
      qs:
        'token': process.env.HUBOT_SLACK_ADMIN_TOKEN
    }
    request.get options, (err, res, body) ->
      json = JSON.parse(body)
      unless json.ok
        return call.send(json.error)
      name = json.team.name
      call.end(formPage(name))

  robot.router.post '/slack/invite', (req, call) ->
    payload = req.body
    name = payload.name
    email = payload.email
    unless email
      return call.send(400)
    options = {
      url: "https://slack.com/api/users.admin.invite"
      qs:
        'token': process.env.HUBOT_SLACK_ADMIN_TOKEN
        'email': email
        'set_active': true
    }
    request.post options, (err, res, body) ->
      json = JSON.parse(body)
      unless json.ok
        return call.end(errorPage(json.error))
      robot.send({ room: ROOM }, "#{email} をチームに招待しました。")
      call.end(submitPage(name, email))
