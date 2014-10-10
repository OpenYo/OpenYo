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

    get '/' do
      erb :top
    end
    post '/yo/' do
      if c = Yo::checkApiVersion(params[:api_ver])
        halt 400, c
      end
      Yo::sendYo(@database, params[:api_token], params[:username])
    end
    post '/yoall/' do
      if c = Yo::checkApiVersion(params[:api_ver])
        halt 400, c
      end
      Yo::yoAll(@database, params[:api_token])
    end
    get '/friends_count/' do
      if c = Yo::checkApiVersion(params[:api_ver])
        halt 400, c
      end
      Yo::friends_count(@database, params[:api_token])
    end
    get '/list_friends/' do
      if c = Yo::checkApiVersion(params[:api_ver])
        halt 400, c
      end
      Yo::list_friends(@database, params[:api_token])
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
      Yo::addImkayac(@database, params[:username], params[:password], params[:kayac_id], params[:kayac_pass], params[:kayac_sec])
    end
    post '/config/new_api_token/' do
      Yo::newApiToken(@database, params[:username], params[:password])
    end
    post '/config/revoke_api_token/' do
      Yo::revokeApiToken(@database, params[:username], params[:password], params[:api_token])
    end
    post '/config/list_tokens/' do # デバッグ用API
      Yo::listTokens(@database, params[:username], params[:password])
    end
    post '/config/add_gcm_id/' do
      Yo::addGCMId(@database, params[:username], params[:password], params[:proj_num], params[:reg_id])
    end
  end
end
