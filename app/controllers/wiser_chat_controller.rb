class WiserChatController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    puts ""
    puts "Session Initialized"
  end

  def client_connected
    puts "Action: Client Connected"
  end

  def new_message
    puts "Action: New Message"
    @channel_name, @user = get_channel_and_user(message)
    send_user_message(@channel_name, @user, message[:msg_body])
  end

  def new_user
    puts "Action: New User"
    @channel_name, @user = get_channel_and_user(message)
    send_system_message(@channel_name, "#{@user.name} is now connected!")
    add_channel_user(@channel_name, @user)
    send_user_list(@channel_name)
  end

  def delete_user
    puts "Action: Delete User"
    @channel_name, @user = get_channel_and_user(connection_store[:user])
    send_system_message(@channel_name, "#{@user.name} disconnected!")
    remove_channel_user
    send_user_list(@channel_name)
  end

  private

  def send_user_message(channel_name, user, message_content)
    msg = WiserChatMessage.create(user: user, channel: channel_name, content: message_content)
    data = { user_id: user.id, user_name: user.name, msg_body: msg.content, channel: msg.channel }
    WebsocketRails[channel_name].trigger "new_message", data
  end

  def send_system_message(channel_name, msg)
    data = { user_id: 0, user_name: "System", msg_body: msg, channel: channel_name }
    WebsocketRails[channel_name].trigger "system_message", data
  end

  def send_user_list(channel_name)
    puts "Action: Broadcast user list for #{channel_name} channel"
    all_users = connection_store.collect_all(:user)
    channel_users = all_users.map{|u| u if u[:channel_name] == channel_name}.compact
    WebsocketRails[channel_name].trigger "user_list", channel_users
  end

  def get_channel_and_user(data)
    return data[:channel_name], User.find(data[:id])
  end

  def add_channel_user(channel_name, user)
    connection_store[:user] = { id: user.id, name: user.name, channel_name: channel_name }
  end

  def remove_channel_user
    connection_store[:user] = nil
  end

end