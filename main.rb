require 'sinatra'
require 'sinatra/reloader' if development? # Only used in development/locally.
require 'pg'

enable :sessions


get '/' do
  erb :index
end





