
get '/home' do
    # if is_logged_in?()
        
        
    # # locals: << :songs songs,
        
    # end

    # Send request to API to get top 10 popular songs
    url = URI("https://shazam.p.rapidapi.com/charts/track?locale=en-US&pageSize=10&startFrom=0")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = "#{ENV["SHAZAM_API_KEY"]}"
    request["x-rapidapi-host"] = 'shazam.p.rapidapi.com'

    response = http.request(request)
    
    response_hash = JSON.parse(response.read_body)

    song_list = response_hash['tracks']

    playlists = get_playlist(current_user[0]["email"])

    songs = get_songs(current_user[0]["id"])

    erb :index, locals: {playlists: playlists, song_list: song_list, songs: songs,} 
        

end

# Search for a song/artist  
get '/search' do 
    
    # Send request to API to get a list of songs/artist/albums with search_term name
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
  
    erb :'/music/list', locals: {response_hash: response_hash,  
        
    }
  
end

# display a single song
get '/display' do 

    # Send request to API to return a particular song selected from list of songs/artist/album
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

    if is_logged_in?()
        user_playlist = get_playlist(current_user[0]['email'])

        song = title
        user_id = session[:id]
        playlist = response['playlist']

    end

    erb :'/music/search', locals: {response: response, title: title, artist: artist, cover: cover, user_playlist: user_playlist}
  
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


# Create a playlist page
get '/playlist/create' do 

    erb :'music/new_playlist'
end


# Create a new playlist in the database
post '/playlist' do 
    playlist_name = params[:playlist_name]
    user_name = current_user[0]["email"]

    create_new_playlist(playlist_name, user_name)

    redirect '/'
end

# Edit a playlist
get '/playlist/:playlist_name/edit' do |playlist_name|
    # Look up the food by id, and pass it to the template
    params = [playlist_name]
    results = run_sql("select * from saved_songs where playlist = $1;", params)

    playlist = results[0]["playlist"]

    erb :'/music/edit', locals: {songs: results, playlist: playlist}
end

# Delete a song inside a playlist

delete '/playlist/edit/:song/delete' do |song|

    song_name = params["song_name"]

    params = [song]

    run_sql("delete from saved_songs where song = $1", params)

    redirect '/'

end

# Delete a whole playlist
delete '/playlist/:playlist_name' do |playlist_name|

    params = [playlist_name]

    run_sql("delete from playlist where playlist_name = $1", params)

    redirect '/'

end
