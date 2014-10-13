require "bundler/setup"
require "sinatra/base"
require "rack/ssl"
require "omniauth"
require "octokit"
require "omniauth/strategies/github"

require_relative ".env.rb"

LAYOUT = lambda do |body|
  <<-HTML
<!doctype html>
<html>
  <head>
    <title>CoderDojo SV Mentortron</title>
    <style>
    body { padding-top: 100px; padding-left: 200px; font-family: "Helvetica Neue", "Helvetica", "Arial", sans-serif; font-size: 16px; }
    a { text-decoration: none; }
    p { max-width: 700px; }
    </style>
  </head>
  <body>
    #{body}
  </body>
</html>
  HTML
end

class Mentortron < Sinatra::Base
  APP_ROOT = File.expand_path('..', __FILE__)
  env = File.join(APP_ROOT, '.env.rb')
  load env if File.file? env

  enable :sessions
  use Rack::SSL unless development?
  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"]
  end

  get "/" do
    erb LAYOUT[<<-HTML
<p>
  Hi there. You might've found this page after being invited to join the ranks
  of Silicon Valley CoderDojo's mentor team! If that's something you're interested
  in, you'll need to have a GitHub account. If you don't have one yet, fret not!
  You can <a href="https://github.com/signup/free" target="_blank">create one here</a>.

  Once you have one just press the button below!
</p>
<form action="/auth/github" method="get"><input type="submit" value="Become a Mentor"/></form>
    HTML
    ]
  end

  get "/auth/github/callback" do
    auth = request.env["omniauth.auth"]
    login = auth.extra.raw_info.login
    if add_to_mentors(login)
      LAYOUT[<<-HTML
<p>
  Thanks #{login}, You've been invited to become a mentor!
  Check your primary GitHub email address for the invitation link. Make sure that you're logged into GitHub in the browser that you open the link with.

  Onve you've joined check out the <a href="https://github.com/coderdojosv/mentor-discussion">mentor discussions</a> and let us know if you've got any ideas for cool stuff.
</p>
      HTML
      ]
    else
      LAYOUT[<<-HTML
<p class="yikes">
  Yikes! It looks like something went wonky. You should definitely email
  <a href="mailto:steven@nuclearsandwich.com">@nuclearsandwich</a> and let him
  know.
</p>
      HTML
      ]
    end
  end

  error do
    LAYOUT[<<-HTML
<h3>Confound it all! Looks like something went wonky.</h3>

<p>
Well I have no idea what happened, but whatever it was, it wasn't what we wanted.

If you could kindly <a href="https://github.com/coderdojosv/mentortron/issues/new">Open an issue</a> letting me know what you were doing when you got this error message. I'd sure appreciate it.

Thanks ever so much!
</p>
    HTML
    ]
  end

  helpers do
    def add_to_mentors login
      client = Octokit::Client.new(access_token: ENV["DOJOBOT_TOKEN"])
      client.add_team_membership(ENV["MENTORS_TEAM_ID"], login)
    end
  end

  run! if app_file == $0
end
