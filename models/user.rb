require 'bcrypt'

def create_user(email, name, img_url, password) 

    password_digest = BCrypt::Password.create(password) # This makes sure your users password is encrypted in the database!


    sql_query = "insert into users(email, name, img_url, password_digest) values ($1, $2, $3, $4);"
    
    params = [email, name, img_url, password_digest]
    
    run_sql(sql_query, params)

end

def find_user_by_email(email) 
    sql_query = "select * from users where email = $1"
    params = [email]
    results = run_sql(sql_query, params)

    # Sould return either a single User hash, or nil if not found
    if results.to_a.length > 0
        return results[0]
    else
        return nil
    end
    
end

def find_user_by_id(id) 
    sql_query = "select * from users where id = $1"
    params = [id]
    results = run_sql(sql_query, params)

    # Sould return either a single User hash, or nil if not found
    if results.to_a.length > 0
        return results
    else
        return nil
    end
    
end
