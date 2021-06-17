
get '/music' do

    erb :index
end

# Search for a song/artist  
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
  
    erb :'/music/list', locals: {response_hash: response_hash, songs: songs }
  
end

# display a single song
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


get '/playlist/create' do 

    erb :'music/new_playlist'
end

post '/playlist' do 
    playlist_name = params[:playlist_name]

    create_new_playlist(playlist_name)

    redirect '/'
end