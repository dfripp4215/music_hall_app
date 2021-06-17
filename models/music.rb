def get_playlist (user_name)
    run_sql("select * from playlist where use_name = '#{user_name}'")
end

def create_playlist (playlist_name, song, artist, user_name)
    sql_query = "insert into playlist(playlist_name, song, artist, user_name) values ($1, $2, $3, $4);"

    params = [playlist_name, song, artist, user_name]

    run_sql(sql_query, params)
end

defr create_new_playlist(playlist_name)

    sql_query = "insert into playlist(playlist_name) values ($1);"

    params = [playlist_name]

    run_sql(sql_query, params)

end