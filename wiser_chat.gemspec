# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wiser_chat/version'

Gem::Specification.new do |s|
  s.name          = "wiser_chat"
  s.version       = WiserChat::VERSION
  s.authors       = ["Kenneth John Balgos"]
  s.email         = ["kennethjohnbalgos@gmail.com"]
  s.description   = "Enable real-time chat easily in your Ruby on Rails application."
  s.summary       = "Awesome chat on fire!"
  s.homepage      = "https://github.com/kennethjohnbalgos/wiser_chat"
  s.license       = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|s|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "redis", "3.2.0"
  s.add_dependency "websocket-rails", "0.7.0"

  s.post_install_message = "Welcome to WiserChat v#{WiserChat::VERSION}!"
end
