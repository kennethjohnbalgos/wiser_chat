var chatHooks,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

$(function() {
  $(document).ready(chatHooks);
  $(document).on("page:load", chatHooks);
  return $(document).on("click", ".toggle_chat", function(e) {
    e.preventDefault();
    $("#wiser-chat").slideToggle();
    $('#wiser-chat #chat-content').scrollTop(999999);
    return $("#wiser-chat #message").focus();
  });
});

chatHooks = function() {
  if ($("#wiser-chat").size() > 0) {
    return window.chatController = new Chat.Controller($('#wiser-chat').data('uri'), true, $('#wiser-chat').data('channel'));
  }
};

window.Chat = {};

Chat.User = (function() {
  function User(id, name, channel_name) {
    this.id = id;
    this.name = name;
    this.channel_name = channel_name;
    this.serialize = bind(this.serialize, this);
  }

  User.prototype.serialize = function() {
    return {
      id: this.id,
      name: this.name,
      channel_name: this.channel_name
    };
  };

  return User;

})();

Chat.Controller = (function() {
  Controller.prototype.systemMessageTemplate = function(message) {
    var html;
    html = "<div class=\"message\" >\n  <span class=\"system_message\">" + message.msg_body + "</span>\n</div>";
    return $(html);
  };

  Controller.prototype.userMessageTemplate = function(message) {
    var html;
    html = "<div class=\"message\" >\n  <span class=\"label label-default\">" + (moment().format('h:mm:ss a')) + "</span>\n  <b>" + message.user_name + ":</b>\n  " + message.msg_body + "\n</div>";
    return $(html);
  };

  Controller.prototype.userListTemplate = function(userList) {
    var i, len, user, userHtml;
    userHtml = "";
    for (i = 0, len = userList.length; i < len; i++) {
      user = userList[i];
      userHtml = userHtml + ("<li>" + user.name + "</li>");
    }
    return $(userHtml);
  };

  function Controller(url, useWebSockets, channelName) {
    this.createGuestUser = bind(this.createGuestUser, this);
    this.updateUserList = bind(this.updateUserList, this);
    this.sendMessage = bind(this.sendMessage, this);
    this.newMessage = bind(this.newMessage, this);
    this.systemMessage = bind(this.systemMessage, this);
    this.bindEvents = bind(this.bindEvents, this);
    this.messageQueue = [];
    this.dispatcher = new WebSocketRails(url, useWebSockets);
    this.dispatcher.on_open = this.createGuestUser;
    this.channel = this.dispatcher.subscribe(channelName);
    this.bindEvents();
  }

  Controller.prototype.bindEvents = function() {
    this.channel.bind('new_message', this.newMessage);
    this.channel.bind('system_message', this.systemMessage);
    this.channel.bind('user_list', this.updateUserList);
    $('#wiser-chat #send').on('click', this.sendMessage);
    return $('#wiser-chat #message').keypress(function(e) {
      if (e.keyCode === 13) {
        e.preventDefault();
        if ($.trim($('#wiser-chat #message').val()) !== "") {
          return $('#wiser-chat #send').click();
        }
      }
    });
  };

  Controller.prototype.systemMessage = function(message) {
    return this.appendMessage(message, true);
  };

  Controller.prototype.newMessage = function(message) {
    return this.appendMessage(message, false);
  };

  Controller.prototype.sendMessage = function(event) {
    var data, message;
    event.preventDefault();
    message = $('#wiser-chat #message').val();
    data = {
      id: this.user.id,
      msg_body: message,
      channel_name: this.channel.name
    };
    this.dispatcher.trigger('new_message', data);
    return $('#wiser-chat #message').val('');
  };

  Controller.prototype.updateUserList = function(userList) {
    return $('#wiser-chat #chat-users').html(this.userListTemplate(userList));
  };

  Controller.prototype.appendMessage = function(message, from_system) {
    var messageTemplate;
    if (from_system) {
      messageTemplate = this.systemMessageTemplate(message);
    } else {
      messageTemplate = this.userMessageTemplate(message);
    }
    $('#wiser-chat #chat-messages').append(messageTemplate);
    $('#wiser-chat #chat-content').scrollTop(999999);
    return $('#wiser-chat #chat-messages .message').last().hide().fadeIn();
  };

  Controller.prototype.createGuestUser = function() {
    this.user = new Chat.User($("#wiser-chat #name").data('id'), $("#wiser-chat #name").val(), this.channel.name);
    return this.dispatcher.trigger('new_user', this.user.serialize());
  };

  return Controller;

})();