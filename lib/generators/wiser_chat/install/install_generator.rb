require 'rails'
module WiserChat
  module Generators
    # Install generator that creates migration file from template
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      class_option :js_manifest, :type => :string, :aliases => "-m", :default => 'application.js',
                   :desc => "Javascript manifest file to modify (or create)"

      def create_events_initializer_file
        timestamp = Time.now.strftime("%Y%m%d%H%M%S")
        template 'events.rb', File.join('config', 'events.rb')
        template 'websocket.rb', File.join('config', 'initializers', 'websocket_rails.rb')
        template 'stylesheet.css', File.join('app', 'assets', 'stylesheets', 'wiser_chat.css')
        template 'migration.rb', File.join('db', 'migrate', "#{timestamp}_create_wiser_chat_messages.rb")
      end

      def inject_websocket_rails_client
        js_manifest = options[:js_manifest]
        js_path  = "app/assets/javascripts"
        create_file("#{js_path}/#{js_manifest}") unless File.exists?("#{js_path}/#{js_manifest}")
        append_to_file "#{js_path}/#{js_manifest}" do
          out = ""
          out << "\n"
          out << "//= require jquery.moment"
          out << "\n"
          out << "//= require websocket_rails/main"
          out << "\n"
          out << "//= require wiser_chat"
        end
      end
    end
  end
end