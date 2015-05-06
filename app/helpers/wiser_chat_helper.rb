module WiserChatHelper
  def wiser_chat(channel)
    render "wiser_chat/box", channel: channel
  end
end