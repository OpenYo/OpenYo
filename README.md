OpenYo
======
[![Code Climate](https://codeclimate.com/github/nna774/OpenYo/badges/gpa.svg)](https://codeclimate.com/github/nna774/OpenYo)

Yo のようなプロプラエタリなサービスに依存してはいけない。自由なYo 実装が必要である。

# 仕様 Ver. 0.1

user は一意なuser_ID を持つ。

## API

### Create User

ユーザ登録

* POST request
 * api_ver, username, password のパラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/config/create_user/`

api_token を含んだレスポンスが返ってきます。

成功時
````JSON
{"code": 200, "result": "API_TOKEN"}
````
失敗時
````JSON
{"code": 400, "result": "失敗の理由"}
````

### send yo

user_ID を指定してYo を送る。

* POST request
 * api_ver, api_token とusername パラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/yo/`

### Yo ALL

Yo ALL

* POST request
 * api_ver と api_token パラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/yoall/`

### Count Total Friends

一度でもYo を受けたり、送ったりした人の数。

* GET request
 * api_ver と api_token パラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/friends_count/`

### List Friends

一度でもYo を受けたり、送ったりした人の一覧。

* GET request
 * api_ver と api_token パラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/list_friends/`

### add imkayac

[`im.kayac.com`](im.kayac.com) への通知の設定をします。
iPhone への通知はこれを通じて行なえます。他にも、Jabber, Google Talk へ通知もできるらしいです。

* POST request
 * 必須でapi_ver, username, password, kayac_id のパラメータをもつ。任意で、kayac_pass, kayac_sec のパラメータを持つ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/config/add_imkayac/`

create user の時に設定したusername, password をパラメータに渡し、im.kayac.com のユーザー名をkayac_id に入れてください。
im.kayac のほうで、パスワード認証や、秘密鍵認証の設定を行なっている人は、それぞれをパラメータに入れてください。

## New API Token

新しいデバイスを使いはじめた等で、新しいAPI token が必要になったらお使いください。
毎回新しいトークンを作って使い捨てるとかやめてください……

* POST request
 * api_ver と username, password パラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/config/new_api_token/`

## List API Token

今までに取得したAPI Token の一覧を取得する。(できないほうがいい？)
当面はデバッグ用API として残します。(API Ver が変わる時に廃止されるかもしれません)

* GET request
 * api_ver と username, password パラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/config/list_tokens/`

## add GCM Id

Android 通知用のAPI
あらかじめAndroid クライアント作者と協力して、GCM のプロジェクトナンバーと、通知用のtoken を教えてもらい、
`GCMApiToken` テーブル に`(projNum, token)` のペアとして挿入されている必要があります。

* POST request
 * api\_ver と username, password, proj\_num, reg\_id パラメータをもつ。
 * api_ver=0.1
 * uri: `http://ENDPOINT/config/add_gcm_id/`

`proj_num` がGCM のProject Number, `reg_id` がregistration id です。

## Callback

GET reqest でusername パラメータにuser_ID が入る。

## memo

### notify の方法

とりあえず
* [`im.kayac.com`](http://im.kayac.com/)
* Callback
* Yo API
* Other OpenYo server

ぐらいを考えています。

### send yo

カンマ区切りで複数ユーザに送れると便利かも。

# License

GNU AFFERO GENERAL PUBLIC LICENSE 3.0 or any later version
