# Huboco

![icon.png](https://raw.githubusercontent.com/hico-horiuchi/huboco/master/data/icon.png)

Huboco(ひゅぼ子)は、Hubot製のチャットボットです。  
Slackの研究室チームでの利用を目的に、研究のお手伝いができるよう開発中です。

## Install

Herokuでの簡単な導入説明。

    $ heroku create --stack cedar huboco
    $ heroku config:set HUBOT_HEROKU_KEEPALIVE_URL=$(heroku apps:info -s  | grep web-url | cut -d= -f2)
    $ heroku config:set HUBOT_PING_PATH="/huboco/ping"
    $ heroku config:set HUBOT_SLACK_TOKEN=""
    $ heroku config:set HUBOT_SLACK_ADMIN_TOKEN=""
    $ heroku config:set HUBOT_DOCOMO_DIALOGUE_API_KEY=""
    $ heroku config:set HUBOT_IMGUR_ALBUM_ID=""
    $ heroku config:set HUBOT_IMGUR_CLIENT_ID=""
    $ heroku config:set HUBOT_GITHUB_ACCESS_TOKEN=""
    $ heroku config:set TZ=Asia/Tokyo
    $ git push heroku master

## Commands

<table>
  <tbody>
    <tr>
      <td rowspan="2"><tt>anime.coffee</tt></td>
      <td><tt>anime</tt></td>
      <td>今期放送中のアニメの一覧を表示</td>
    </tr>
    <tr>
      <td><tt>anime &lt;title&gt;</tt></td>
      <td>今期のアニメをタイトルで検索</td>
    </tr>
    <tr>
      <td><tt>crontab.coffee</tt></td>
      <td><tt>crontab</tt></td>
      <td>トピックに設定されたcronを表示</td>
    </tr>
    <tr>
      <td><tt>github.coffee</tt></td>
      <td><tt>gh &lt;user&gt;/&lt;repo&gt; &lt;id&gt;</tt></td>
      <td>リポジトリのIssueまたはPull Requestの情報を表示</td>
    </tr>
    <tr>
      <td rowspan="2"><tt>help.coffee</tt></td>
      <td><tt>help</tt></td>
      <td>コマンドの一覧を表示</td>
    </tr>
    <tr>
      <td><tt>help &lt;command&gt;</tt></td>
      <td>コマンドの検索結果を表示</td>
    </tr>
    <tr>
      <td rowspan="4"><tt>huboco.coffee</tt></td>
      <td><tt>hello</tt></td>
      <td>時刻に応じて簡単な挨拶</td>
    </tr>
    <tr>
      <td><tt>version</tt></td>
      <td>Hubotのバージョンを表示</td>
    </tr>
    <tr>
      <td><tt>date</tt></td>
      <td>今日の日付を表示</td>
    </tr>
    <tr>
      <td><tt>time</tt></td>
      <td>現在の時刻を表示</td>
    </tr>
    <tr>
      <td rowspan="2"><tt>lgtm.coffee</tt></td>
      <td><tt>lgtm</tt></td>
      <td><a href="https://imgur.com/" target="_blank">Imgur</a>の<tt>HUBOT_IMGUR_ALBUM_ID</tt>からLGTM画像を送信</td>
    </tr>
    <tr>
      <td><tt>lgtm &lt;user&gt;/&lt;repo&gt; &lt;id&gt;</tt></td>
      <td>リポジトリのIssueまたはPull RequestにLGTM画像をコメント</td>
    </tr>
    <tr>
      <td><tt>omikuji.coffee</tt></td>
      <td><tt>omikuji</tt></td>
      <td>チャンネルメンバーから1人選んでリプライを送信</td>
    </tr>
    <tr>
      <td rowspan="3"><tt>semi.coffee</tt></td>
      <td><tt>semi</tt></td>
      <td>次のゼミの情報を表示</td>
    </tr>
    <tr>
      <td><tt>semi list</tt></td>
      <td>今後1ヶ月のゼミの情報を表示</td>
    </tr>
    <tr>
      <td><tt>semi changes</tt></td>
      <td>日時が変更になったゼミの一覧を表示</td>
    </tr>
    <tr>
      <td rowspan="2"><tt>thesis.coffee</tt></td>
      <td><tt>thesis</tt></td>
      <td>論文締切の日付を表示</td>
    </tr>
    <tr>
      <td><tt>thesis days</tt></td>
      <td>論文締切までの日数を表示</td>
    </tr>
    <tr>
      <td><tt>z_dialogue.coffee</tt></td>
      <td></td>
      <td>どのコマンドにも一致しない場合に雑談</td>
    </tr>
  </tbody>
</table>

## URLs

<table>
  <tbody>
    <tr>
      <td><tt>httpd.coffee</tt></td>
      <td><tt>GET /huboco/info</tt></td>
      <td>Hubocoの紹介ページを表示</td>
    </tr>
    <tr>
      <td rowspan="2"><tt>invite.coffee</tt></td>
      <td><tt>GET /slack/form</tt></td>
      <td>Slackのチームの招待フォームを表示</td>
    </tr>
    <tr>
      <td><tt>POST /slack/invite</tt></td>
      <td>Slackのチームにユーザーを招待</td>
    </tr>
  </tbody>
</table>

## Cron

<table>
  <tbody>
    <tr>
      <td><tt>crontab.coffee</tt></td>
      <td><tt>data/crontab.json</tt>の定時処理を実行</td>
    </tr>
    <tr>
      <td><tt>semi_cron.coffee</tt></td>
      <td>ゼミの前日9時に通知、発表者にリプライ</td>
    </tr>
 </tbody>
</table>

## SpecialThanks

  - 「[情報共有ツールの情報共有 | JANOG34 Meeting](http://www.janog.gr.jp/meeting/janog34/program/itool.html)」への参加をキッカケに開発を開始しました。
  - アイコンは「[In Spirited We Love Icon Se by Raindropmemory](http://raindropmemory.deviantart.com/art/In-Spirited-We-Love-Icon-Set-Repost-304014435)」を使っています。
