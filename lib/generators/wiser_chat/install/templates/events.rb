WebsocketRails::EventMap.describe do
  subscribe :client_connected,    to: WiserChatController, with_method: :client_connected
  subscribe :new_message,         to: WiserChatController, with_method: :new_message
  subscribe :new_user,            to: WiserChatController, with_method: :new_user
  subscribe :client_disconnected, to: WiserChatController, with_method: :delete_user
end