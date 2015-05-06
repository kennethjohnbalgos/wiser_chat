# WiserChat

Awesome chat on fire!

## Requirements

_WiserChat_ only support Rails >= 3.2 with jQuery.

The following items are required:

 - Redis should be installed in the server, please see [http://redis.io](http://redis.io).
 - `User` model should be available and it should have a `name` method that returns the user name for the chat.
 - WiserChat should be used only when there's a user logged in - `current_user` method should be available.


## Setup

### Gem Installation

Include the following lines in your `Gemfile`:

	gem 'redis', '3.2.0'
    gem 'websocket-rails', '~> 0.7.0'
    gem 'wiser_chat', '~> 0.1.1'

Then run:

	bundle install

After installing the gems, you're now ready to install WiserChat by running this command:

	bundle exec rails generate wiser_chat:install

The install command will generate the necessary files as well as the migration for the database. Now, run the migration to create the database table:

	bundle exec rake db:migrate

Lastly, remove the Rack::Lock middleware by adding this line at the end of your `development.rb` file:

	config.middleware.delete Rack::Lock

## Usage

### Important: Run the websocket

WiserChat will use websocket and redis, you need to start the websocket server:

	bundle exec rake websocket_rails:start_server

The websocket logs will be available at `log/websocket_rails.log` and `log/websocket_rails_server.log`.

### Rendering the chat box

You can always use this helper method in your view:

	= wiser_chat(@channel_name)

You need to specify the `@channel_name` to group the chat conversations. You can have different channels in different pages, but you cannot have multiple channels in a single page.

Channel name is very sensitive, use alpha-numeric characters only. In other words, do not use any special characters in your channel name.

### Stylesheet

Include the `wiser_chat` stylesheet into your `app/assets/stylesheets/application.css`:

	*= require wiser_chat

By default, the chat box will be hidden and you need to toggle the `#wiser-chat` element to display it. But you can create a link with `toggle_chat` class to add a display control for the chat box.

	= link_to "Chat", "#", class: "toggle_chat"

However, you can always customize it or event create your own appearance by editing the `app/assets/stylesheets/wiser_chat.css`.

## Capistrano

You need to run the websocket in your server and adding the codes below will make it easier for you to do it using the capistrano commands. Append this in your `deploy.rb` file:

	set :stage, lambda{ config_name.split(':').last }
	namespace :websocket do
	  desc 'Stop websocket deamon'
	  task :stop do
	    on roles(:app), in: :sequence, wait: 5 do
	      within current_path do
	        websocket_pid = current_path.join('tmp/pids/websocket_rails.pid')
	        if test("[ -f #{websocket_pid} ]") then
	          with rails_env: fetch(:stage) do
	            rake 'websocket_rails:stop_server'
	          end
	        else
	          info "WebsocketRails is not running, not need to be stopped."
	        end
	      end
	    end
	  end

	  desc 'Start websocket deamon'
	  task :start do
	    on roles(:app), in: :sequence, wait: 5 do
	      within current_path do
	        with rails_env: fetch(:stage) do
	          info 'Start WebsocketRails server'
	          rake 'websocket_rails:start_server'
	        end
	      end
	    end
	  end
	end

After that, these capistrano commands will do the work:

	bundle exec cap production websocket:start

You can also kill the websocket using this capistrano command:

	bundle exec cap production websocket:stop


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Support
Open an issue in https://github.com/kennethjohnbalgos/wiser_chat if you need further support or want to report a bug.

## License

The MIT License (MIT) Copyright (c) 2015 iKennOnline

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
