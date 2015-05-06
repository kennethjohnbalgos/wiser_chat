module WiserChatHelper
  def wiser_chat(channel, initial_messages = 10)
    render "wiser_chat/box", channel: channel, initial_messages: initial_messages
  end
end