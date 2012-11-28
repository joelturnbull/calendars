class GoogleApi

  client   = Google::APIClient.new
  api      = 'calendar'
  calendar = client.discovered_api(api,'v3')

  #oath
  client.authorization.client_id     = "655945253994.apps.googleusercontent.com"
  client.authorization.client_secret = "z-esz43nThYq7q_DRmxwZFRf"
  client.authorization.redirect_uri  = "localhost:3000/oauth2callback"
  #client.authorization.redirect_uri  = "https://www.starkgarden.com/oauth2callback"
  
  client.authorization.scope = "https://www.googleapis.com/auth/#{api}.me"
  
  # Request authorization
  redirect_uri = client.authorization.authorization_uri

  binding.pry
  client.authorization.code = '....'
  client.authorization.fetch_access_token!

end
