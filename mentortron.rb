require "sinatra/base"

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
  use Omniauth::Builder do
    provider :github, ENV["GITHUB_CLIENT_KEY"], ENV["GITHUB_CLIENT_SECRET"]
  end

  get "/" do
    erb LAYOUT['<form action="/auth/github" method="get"><input type="submit" value="Become a Mentor"/></form>']
  end

  get "/auth/github/callback" do
    request.env['omniauth']
  end

  run! if app_file == $0
end
