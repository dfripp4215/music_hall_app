
get '/home' do
    if is_logged_in?()
        playlists = get_playlist(current_user[0]["email"])


        songs = get_songs(current_user[0]["id"])
    end

    erb :index, locals: {playlists: playlists, songs: songs}
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

    user_playlist = get_playlist(current_user[0]['email'])

    song = title
    user_id = session[:id]
    playlist = response['playlist']

    

    add = add_to_playlist(song, artist, playlist, user_id)

    

    erb :'/music/search', locals: {response: response, title: title, artist: artist, cover: cover, user_playlist: user_playlist, add: add}
  
end

# Go to new_playlist page. Create a playlist
get '/playlist/create' do 

    erb :'music/new_playlist'
end

# Create a blank playlist in the database
post '/playlist' do 
    playlist_name = params[:playlist_name]
    user_name = current_user[0]["email"]

    create_new_playlist(playlist_name, user_name)

    redirect '/'
end

# Add a song to a playlist
post '/display/create' do 

    playlist = params['playlist']
    song = params['title']
    artist = params['artist']
    user_id = current_user[0]["id"]

    

    add_to_playlist(song, artist, playlist, user_id)

    redirect '/'
end