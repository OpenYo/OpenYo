# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'rack/rewrite'
require 'mysql2'

require_relative 'yo'

module Portfolio
  class App < Sinatra::Base

    configure :development do
      register Sinatra::Reloader
      also_reload "#{File.dirname(__FILE__)}/yo.rb"
    end

    before do
      @database = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "root", :database => "OpenYo")
    end
    
    get '/' do
      "<body bgcolor=\"#267CA7\"><a href=\"https://github.com/nna774/OpenYo/\">Yo!</a>"
    end
    post '/yo' do
      "please send to /yo/\n"
    end
    post '/yo/' do
      if params[:api_ver] == "0.1"
        return sendYo(@database, params[:api_token], params[:username])
      end
      "bad api_ver\n{0.1}\n"
    end
    get '/yo/' do
      redirect "/", 301
    end
    get '/friends_count' do
      redirect "/friends_count/", 301
    end
    get '/friends_count/' do
      if params[:api_ver] == "0.1"
        return friends_count(@database, params[:api_token])
      end
      "bad api_ver\n{0.1}\n"
    end
  end
end
