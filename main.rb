require 'sinatra'
require 'sinatra/reloader' if development? # Only used in development/locally.
require 'pg'
require 'uri'
require 'net/http'
require 'openssl'

enable :sessions

require_relative 'db/db'
require_relative 'models/music'
require_relative 'models/user'
require_relative 'helpers/session'
require_relative 'controllers/music_controller'
require_relative 'controllers/user_controller'
require_relative 'controllers/session_controller'
  

get '/' do
  
  redirect '/home'
end

get '/about' do

  erb :about
end

