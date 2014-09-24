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
    return returnMsg 400, "unknown api_token: #{api_token}" if token_user.nil?
    userExist = nil
    database.query("SELECT * FROM apiToken WHERE userId='#{database.escape("#{username}")}' LIMIT 1").each do |r|
      userExist = r["userId"]
    end
    return returnMsg 400, "unknown username: #{username}\n" if userExist.nil?

    addFriendEachOther(database, token_user, username)

    notify(database, username, token_user)
    returnMsg 200, "send Yo!"
  end

  def yoAll(database, api_token)
    token_user = getTokenUser(database, api_token)
    return returnMsg 400, "unknown api_token: #{api_token}." if token_user.nil?

    database.query("SELECT * FROM friends WHERE userId='#{token_user}'").each do |r|
      notify(database, r["friend"], token_user)
    end
    returnMsg 200, "send Yo ALL!"
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
    return returnMsg 400, "unknown api_token: #{api_token}" if token_user.nil?
    count = 0
    database.query("SELECT COUNT(*) FROM friends WHERE userId='#{token_user}'").each do |r|
      count = r["COUNT(*)"]
    end
    return returnMsg 200, count
  end

  def list_friends(database, api_token)
    token_user = getTokenUser(database, api_token)
    return returnMsg 400, "unknown api_token: #{api_token}" if token_user.nil?
    list = []
    database.query("SELECT * FROM friends WHERE userId='#{token_user}'").each do |r|
      list << r["friend"]
    end
    return returnMsg 200, list.to_s
  end

  def createUser(database, username, password)
    exists = nil
    database.query("SELECT * FROM password WHERE userId='#{database.escape("#{username}")}' LIMIT 1").each do |r|
      exists = r["userId"]
    end
    if not exists.nil?
      return returnMsg 400, "username #{username} is already exist."
    end
    usernameOrig = username
    username.upcase!
    if (/^[A-Z0-9]{1,20}$/ =~ username).nil? # ユーザ名は[A-Z0-9] の1〜20文字という制限でいいかな？
      return returnMsg 400, "username should match [A-Z0-9]{1,20}. #{usernameOrig} is not match."
    end
    if password.nil?
      return returnMsg 400, "password should not be empty."
    end
    salt = SecureRandom.uuid
    newToken = SecureRandom.uuid
    hash = Digest::SHA512.hexdigest(salt + password)
    database.query("INSERT INTO password VALUES('#{database.escape("#{username}")}', '#{salt}', '#{hash}')")
    database.query("INSERT INTO apiToken VALUES('#{database.escape("#{username}")}', '#{newToken}')")
    return returnMsg 200, newToken
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
      returnMsg 400, "bad api_ver\n{0.1}."
    else
      nil
    end
  end
  def checkPassword(database, username, password)
    exists = nil
    salt = nil
    hash = nil
    database.query("SELECT * FROM password WHERE userId='#{database.escape("#{username}")}' LIMIT 1").each do |r|
      exists = r["userId"]
      salt = r["salt"]
      hash = r["hash"]
    end
    return false if exists.nil?
    return Digest::SHA512.hexdigest(salt + password) == hash
  end
  def returnMsg(code, msg)
    return "{\"code\": #{code}, \"result\": \"#{msg}\"}\n"
  end
  module_function :getTokenUser, :sendYo, :yoAll, :notify, :friends_count, :list_friends, :createUser, :addImkayac, :checkApiVersion, :checkPassword, :returnMsg
end
