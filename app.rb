# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'rack/rewrite'
require 'mysql2'

require_relative 'yo'
require_relative 'config'

module Portfolio
  class App < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      also_reload "#{File.dirname(__FILE__)}/yo.rb"
      also_reload "#{File.dirname(__FILE__)}/view.rb"
      also_reload "#{File.dirname(__FILE__)}/config.rb"
    end

    configure do
      enable :logging
      file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
      file.sync = true
      use Rack::CommonLogger, file
    end

    register Sinatra::CrossOrigin
    enable :cross_origin

    before do
      @database = Mysql2::Client.new(:host => DBHOST, :username => DBUSER, :password => DBPASS, :database => DBNAME)
    end

    before '/config/*' do
      if c = Yo::checkApiVersion(params[:api_ver])
        halt 400, c
      end
      if request.path == "/config/create_user/"
        return true
      end
      if not Yo::checkPassword(@database, params[:username], params[:password])
        halt 401, (Yo::returnMsg 401, "authentication failed.")
      end
    end

    before /(yo|yoll|friends_count|list_friends|history)/ do
      if c = Yo::checkApiVersion(params[:api_ver])
        halt 400, c
      end
    end

    get '/' do
      erb :top
    end
    post '/yo/' do
      Yo::sendYo(@database, params[:api_token], params[:username])
    end
    post '/yoall/' do
      Yo::yoAll(@database, params[:api_token])
    end
    get '/friends_count/' do
      Yo::friends_count(@database, params[:api_token])
    end
    get '/list_friends/' do
      Yo::list_friends(@database, params[:api_token])
    end
    get '/history/' do
      max = 1000
      count = nil
      count = "20" if (params[:count].nil? or params[:count].to_i == 0 or params[:count].to_i > max)
      count = count || params[:count].to_i.to_s
      Yo::history(@database, params[:api_token], count)
    end
    get '/sender/:token' do
      @token = params[:token]
      erb :sender
    end
    post '/config/create_user/' do
      Yo::createUser(@database, params[:username], params[:password])
    end
    post '/config/change_password/' do
      Yo::changePassword(@database, params[:username], params[:password], params[:new_password])
    end
    post '/config/add_imkayac/' do
      Yo::addImkayac(@database, params[:username], params[:kayac_id], params[:kayac_pass], params[:kayac_sec])
    end
    post '/config/new_api_token/' do
      Yo::newApiToken(@database, params[:username])
    end
    post '/config/revoke_api_token/' do
      Yo::revokeApiToken(@database, params[:username], params[:api_token])
    end
    get '/config/list_tokens/' do # デバッグ用API
      Yo::listTokens(@database, params[:username])
    end
    post '/config/add_gcm_id/' do
      Yo::addGCMId(@database, params[:username], params[:proj_num], params[:reg_id])
    end
    get '/login/' do
      erb :login
    end
    get '/signup/' do
      erb :signup
    end
    get '/user/:user' do
      @user = params[:user]
      erb :user
    end
    get '/mypage/' do
      erb :mypage
    end
    get '/mypage/imkayac/' do
      erb :imkayac
    end
  end
end
