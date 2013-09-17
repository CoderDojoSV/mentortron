require "bundler/setup"
require "sinatra/base"
require "rack/ssl"
require "omniauth"
require "omniauth/strategies/github"

LAYOUT = lambda do |body|
  <<-HTML
<!doctype html>
<html>
  <head>
    <title>CoderDojo SV Mentortron</title>
    <style>
    </style>
  </head>
  <body>
    #{body}
  </body>
</html>
  HTML
end

class Mentortron < Sinatra::Base
  enable :sessions
  use Rack::SSL unless development?
  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"]
  end

  get "/" do
    erb LAYOUT['<form action="/auth/github" method="get"><input type="submit" value="Become a Mentor"/></form>']
  end

  get "/auth/github/callback" do
    auth = request.env['omniauth.auth']
    LAYOUT["Your username is #{auth.extra.raw_info.login}"]
  end

  run! if app_file == $0
end
