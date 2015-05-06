WebsocketRails.setup do |config|
  config.standalone = true
  config.redis_options = {host: 'localhost', port: '6379'}
  config.standalone_port = 3245
  config.synchronize = true
end
