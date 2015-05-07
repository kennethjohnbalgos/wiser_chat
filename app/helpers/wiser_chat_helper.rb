module WiserChatHelper
  def wiser_chat(channel, initial_messages = 10)
    render "layouts/wiser_chat", channel: channel, initial_messages: initial_messages
  end
end