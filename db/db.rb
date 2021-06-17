def run_sql (sql_query, params = []) 

    connection = PG.connect(ENV['DATABASE_URL'] || {dbname: 'music_hall'}) # ENV (Environment variables) tries to connect to the production database, if it doesn't connect to it it will connect to your development database and knwo that you are still in development database.

    connection.prepare("statement_name", sql_query) 

    results = connection.exec_prepared("statement_name", params)

    connection.close

    return results

end
