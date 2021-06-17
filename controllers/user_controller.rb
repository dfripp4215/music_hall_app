get '/sign_up' do



    erb :'users/sign_up'
end

post '/sign_up' do

    email = params[:email]
    name = params[:name]
    img_url = params[:img_url]
    password = params[:password]

    create_user(email, name, img_url, password)

    redirect '/home'
end
