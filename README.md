# Mentortron 8000

*Quick and gnarly little Sinatra application to join our mentor team*

## Setup

There's not much to it. You need Ruby 2.0 and Bundler, then you you can just
clone this repository and run `bundle install`.

To run the application server you first need to set some environment variables:

* `GITHUB_CLIENT_ID` - The id of your test GitHub application
* `GITHUB_CLIENT_SECRET` - The secret of your test GitHub application (keep it safe!)
* `DOJOBOT_TOKEN` - A personal token for your Coder Dojo Bot
* `MENTORS_TEAM_ID` - The id of the mentors team for your Coder Dojo

To get a client id and secret [create a GitHub application][app settings]

[app settings]: https://github.com/settings/applications

Once you have those set, you can run the server with just `ruby mentortron.rb`!

It works really well on Heroku with the provided Procfile.

## Contributing

Please submit pull request from non-master branches or use the [GitHub Flow in
the Browser](https://github.com/blog/1557-github-flow-in-the-browser).

Never hesitate to [open an issue](https://github.com/coderdojosv/mentortron/issues/new).
