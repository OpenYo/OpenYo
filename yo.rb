# -*- coding: utf-8 -*-
require 'net/http'
require 'uri'

def sendYo(database, api_token, username)
  token_user = nil
  database.query("SELECT * FROM apiToken WHERE token='#{database.escape("#{api_token}")}' LIMIT 1").each do |r|
    token_user = r["userId"]
  end
  return "unknown apt_token: #{api_token}\n" if token_user.nil?
  userExist = nil
  database.query("SELECT * FROM apiToken WHERE userId='#{database.escape("#{username}")}' LIMIT 1").each do |r|
    userExist = r["userId"]
  end
  return "unknown username: #{username}\n" if userExist.nil?
  "api_token: #{api_token}\nusername: #{username}\ntoken_user: #{token_user}\n"

  addFriendEachOther(database, token_user, username)

  notify(database, username, token_user)
  "send Yo!\n"
end

def addFriendEachOther(database, token_user, username)
  addFriend(database, token_user, username)
  addFriend(database, username, token_user)
end

def addFriend(database, username, friend)
  userExist = nil
  database.query("SELECT * FROM friends WHERE userId='#{database.escape("#{username}")}' AND friend='#{database.escape("#{friend}")}' LIMIT 1").each do |r|
    userExist = r["userId"]
  end
  if userExist.nil?
    database.query("INSERT INTO friends VALUES('#{database.escape("#{username}")}', '#{database.escape("#{friend}")}')")
  end
end

def notify(database, username, token_user)
  # どうしよう
end
