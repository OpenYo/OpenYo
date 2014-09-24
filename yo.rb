# -*- coding: utf-8 -*-
require 'net/http'
require 'uri'
require 'securerandom'
require 'digest/sha2'

module Yo
  def getTokenUser(database, api_token)
    token_user = nil
    database.query("SELECT * FROM apiToken WHERE token='#{database.escape("#{api_token}")}' LIMIT 1").each do |r|
      token_user = r["userId"]
    end
    return token_user
  end

  def sendYo(database, api_token, username)
    token_user = getTokenUser(database, api_token)
    return "{\"code\": 400, \"result\": \"unknown api_token: #{api_token}\"}\n" if token_user.nil?
    userExist = nil
    database.query("SELECT * FROM apiToken WHERE userId='#{database.escape("#{username}")}' LIMIT 1").each do |r|
      userExist = r["userId"]
    end
    return "unknown username: #{username}\n" if userExist.nil?

    addFriendEachOther(database, token_user, username)

    notify(database, username, token_user)
    "{\"code\": 200, \"result\": \"send Yo!\"}\n"
  end

  def yoAll(database, api_token)
    token_user = getTokenUser(database, api_token)
    return "{\"code\": 400, \"result\": \"unknown api_token: #{api_token}\"}\n" if token_user.nil?

    database.query("SELECT * FROM friends WHERE userId='#{token_user}'").each do |r|
      notify(database, r["friend"], token_user)
    end
    "{\"code\": 200, \"result\": \"send Yo ALL!\"}\n"
  end

  def self.addFriendEachOther(database, token_user, username)
    addFriend(database, token_user, username)
    addFriend(database, username, token_user)
  end

  def self.addFriend(database, username, friend)
    userExist = nil
    database.query("SELECT * FROM friends WHERE userId='#{database.escape("#{username}")}' AND friend='#{database.escape("#{friend}")}' LIMIT 1").each do |r|
      userExist = r["userId"]
    end
    if userExist.nil?
      database.query("INSERT INTO friends VALUES('#{database.escape("#{username}")}', '#{database.escape("#{friend}")}')")
    end
  end

  def notify(database, username, fromUser)
    database.query("SELECT * FROM notifyType WHERE userId='#{username}'").each do |r|
      decideType(database, username, fromUser, r["type"])
    end
  end

  def friends_count(database, api_token)
    token_user = getTokenUser(database, api_token)
    return "{\"code\": 400, \"result\": \"unknown api_token: #{api_token}\"}\n" if token_user.nil?
    count = nil
    database.query("SELECT COUNT(*) FROM friends WHERE userId='#{token_user}'").each do |r|
      count = r["COUNT(*)"]
    end
    return "{\"result\": #{count}}\n"
  end

  def list_friends(database, api_token)
    token_user = getTokenUser(database, api_token)
    return "{\"code\": 400, \"result\": \"unknown api_token: #{api_token}\"}\n" if token_user.nil?
    list = []
    database.query("SELECT * FROM friends WHERE userId='#{token_user}'").each do |r|
      list << r["friend"]
    end
    return "{\"code\": 200,\"friends\": #{list.to_s}}\n"
  end

  def createUser(database, username, password)
    exists = nil
    database.query("SELECT * FROM password WHERE userId='#{database.escape("#{username}")}' LIMIT 1").each do |r|
      exists = r["userId"]
    end
    if exists != nil
      return "{\"code\": 400, \"result\": \"username #{username} is already exist.\"}\n"
    end
    usernameOrig = username
    username.upcase!
    if not /[A-Z0-9]{1,20}/ =~ username # ユーザ名は[A-Z0-9] の1〜20文字という制限でいいかな？
      return "{\"code\": 400, \"result\": \"username should match [A-Z0-9]{1,20}. #{usernameOrig} is not match.\"}\n"
    end
    if password.nil?
      return "{\"code\": 400, \"result\": \"password should not be empty.\"}\n"
    end
    salt = SecureRandom.uuid
    newToken = SecureRandom.uuid
    hash = Digest::SHA512.hexdigest(salt + password)
    database.query("INSERT INTO password VALUES('#{database.escape("#{username}")}', '#{salt}', '#{hash}')")
    database.query("INSERT INTO apiToken VALUES('#{database.escape("#{username}")}', '#{newToken}')")
    return "{\"code\": 200, \"result\": \"Your api_token is '#{newToken}'!\", \"api_token\": \#{newToken}\"}\n"
  end

  def addImkayac(database, api_token, password, kayacId, kayacPass, kayacSec)
    token_user = getTokenUser(database, api_token)
    return "{\"code\": 400, \"result\": \"unknown api_token: #{api_token}\"}\n" if token_user.nil?
    return "kayac_id is need.\n" if kayacId.nil?
    database.query("INSERT INTO imkayac VALUES('#{token_user}', '#{database.escape(kayacId)}', #{if kayacPass.nil? then 'NULL' else '#{database.escape(kayacPass)}' end}, #{if kayacSec.nil? then 'NULL' else '#{database.escape(kayacSec)}' end})")
    return "success!\n"
  end
  def checkApiVersion(ver)
    if ver != "0.1" then
      "{\"code\": 400, \"result\": \"bad api_ver\n{0.1}\"}\n"
    else
      nil
    end
  end
  module_function :getTokenUser, :sendYo, :yoAll, :notify, :friends_count, :list_friends, :createUser, :addImkayac, :checkApiVersion
end
