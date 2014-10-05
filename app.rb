# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
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

    before do
      @database = Mysql2::Client.new(:host => DBHOST, :username => DBUSER, :password => DBPASS, :database => DBNAME)
    end
    
    get '/' do
      erb :top
    end
    post '/yo' do
      "please send to /yo/\n"
    end
    post '/yo/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::sendYo(@database, params[:api_token], params[:username])
    end
    get '/yo/' do
      redirect "/", 301
    end
    post '/yoall/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::yoAll(@database, params[:api_token])
    end
    get '/friends_count' do
      redirect "/friends_count/", 301
    end
    get '/friends_count/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::friends_count(@database, params[:api_token])
    end
    get '/list_friends' do
      redirect "/list_friends/", 301
    end
    get '/list_friends/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::list_friends(@database, params[:api_token])
    end
    get '/sender/:token' do
      @token = params[:token]
      erb :sender
    end
    post '/config/create_user/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::createUser(@database, params[:username], params[:password])
    end
    post '/config/change_password/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::changePassword(@database, params[:username], params[:password], params[:new_password])
    end
    post '/config/add_imkayac/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::addImkayac(@database, params[:username], params[:password], params[:kayac_id], params[:kayac_pass], params[:kayac_sec])
    end
    post '/config/new_api_token/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::newApiToken(@database, params[:username], params[:password])
    end
    post '/config/revoke_api_token/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::revokeApiToken(@database, params[:username], params[:password], params[:api_token])
    end
    post '/config/list_tokens/' do # デバッグ用API
      Yo::checkApiVersion(params[:api_ver]) || Yo::listTokens(@database, params[:username], params[:password])
    end
    post '/config/add_gcm_id/' do
      Yo::checkApiVersion(params[:api_ver]) || Yo::addGCMId(@database, params[:username], params[:password], params[:proj_num], params[:reg_id])
    end
  end
end
