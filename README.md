OpenYo
======

Yo のようなプロプラエタリなサービスに依存してはいけない。自由なYo 実装が必要である。

# 仕様 Ver. 0.1

user は一意なuser_ID を持つ。

アカウントの管理はしばらく考えないこととする。

## API

user はapi_token を持っている。

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
 * uri: `http://ENDPOINT/yolall/`

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

GNU AFFERO GENERAL PUBLIC LICENSE
