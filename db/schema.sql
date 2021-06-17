create table playlist (
    id serial primary key, 
    playlist_name TEXT, 
    song TEXT, 
    artist TEXT, 
    user_name TEXT
);

create table users (
    id serial primary key, 
    email TEXT, 
    name TEXT, 
    img_url TEXT, 
    password_digest TEXT
);