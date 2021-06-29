def get_playlist (user_name)

    sql_query = "select * from playlist where user_name = '$1'"

    params = [user_name]

    run_sql(sql_query, params)

end

def get_songs (user_id)

    sql_query = "select * from saved_songs where user_id = $1"

    params = [user_id]

    run_sql(sql_query, params)
end


def add_to_playlist (song, artist, playlist, user_id)
    sql_query = "insert into saved_songs(song, artist, playlist, user_id) values ($1, $2, $3, $4);"

    params = [song, artist, playlist, user_id]

    run_sql(sql_query, params)
end


def create_new_playlist(playlist_name, user_name)

    sql_query = "insert into playlist(playlist_name, user_name) values ($1, $2);"

    params = [playlist_name, user_name]

    run_sql(sql_query, params)

end



