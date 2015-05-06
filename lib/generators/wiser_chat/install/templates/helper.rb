module WiserChatHelper
  def wiser_chat(channel)
    render "layouts/wiser_chat", channel: channel
  end
end