require 'sinatra'
require 'sinatra/reloader' if development? # Only used in development/locally.
require 'pg'
require 'uri'
require 'net/http'
require 'openssl'
require 'HTTParty'

enable :sessions

require_relative 'db/db'
require_relative 'models/music'
require_relative 'models/user'
require_relative 'helpers/session'
require_relative 'controllers/music_controller'
require_relative 'controllers/users_controller' 
require_relative 'controllers/sessions_controller'
require_relative 'controllers/api_controller'


get '/' do

  erb :index
end

get '/search' do 

  search_term = params['search']

  url = URI("https://shazam.p.rapidapi.com/search?term=#{search_term}&locale=en-US&offset=0&limit=5")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["x-rapidapi-key"] = "#{ENV["SHAZAM_API_KEY"]}"
  request["x-rapidapi-host"] = 'shazam.p.rapidapi.com'

  response = http.request(request)

  # Must pass response into JSON.parse because .read_body will output a string even if it's a hash
  response_hash = JSON.parse(response.read_body)

  songs = response_hash["tracks"]["hits"]
  
  #binding.irb

  erb :'/music/list', locals: {response_hash: response_hash, songs: songs }

end

get '/display' do 
  
  search = params['search'] 

  url = URI("https://shazam.p.rapidapi.com/songs/get-details?key=#{search}&locale=en-US")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["x-rapidapi-key"] = "#{ENV["SHAZAM_API_KEY"]}"
  request["x-rapidapi-host"] = 'shazam.p.rapidapi.com'

  response = http.request(request)

  response_hash = JSON.parse(response.read_body)

  title = response_hash["title"]
  artist = response_hash['subtitle']
  cover = response_hash["images"]['coverart']

  erb :'/music/search', locals: {response: response, title: title, artist: artist, cover: cover}

end