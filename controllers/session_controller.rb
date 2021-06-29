get '/login' do 

    erb :'/sessions/login', locals: {error_message: ''}
end

post '/sessions' do 
    
    email = params[:email]
    password = params[:password]
    user = find_user_by_email(email)

    bcrypt_password = BCrypt::Password.new(user['password_digest'])

    if user && bcrypt_password == password # bcrypt has to come first as == is checking the bcrypt hash and not a normal string
        session[:user_id] = user['id']
        redirect '/'
    else
        erb :'/sessions/login', locals: {error_message: 'Incorrect Password'}
    end

end

# Sessions Hash -> Keeps information about the users session

delete '/sessions' do
    
    session[:user_id] = nil

    redirect '/'
end