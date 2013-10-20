QZ.room =
  init: ->
    $form = $('.js-room-message-form')
    $form.on 'ajax:beforeSend', (evt, xhr, settings) ->
      $input = $form.find('.js-room-message-form-message')
      return false unless $input.val().length
      $input.val('')

QZ.room.chat =
  init: ->
    $('.js-room-chat').scroll(QZ.room.chat._onChatScroll)
    return

  _onChatScroll: (event) ->


  _addRawMessage: (html, klass) ->
    $chat = $('.js-room-chat')
    $row = $("<p class='message #{klass}'>#{html}</p>")
    $row.appendTo($chat).hide().fadeIn()
    $chat.stop(true, false).animate({scrollTop: $chat.prop('scrollHeight')})

  addUserMessage: (user, message, klass) ->
    QZ.room.chat._addRawMessage("<strong>#{user}: </strong><span>#{message}</span>", klass)


class Users
  constructor: (@room_id, @container) ->
    @_subscribeChannels()

  _subscribeChannels: =>
    @_subscribeJoin()
    @_subscribeLeave()

  _subscribeJoin: =>
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/users/join", (data) =>
      return if @container.find("li[data-id=\"#{data.user.id}\"]").length
      first = @container.find('li').filter( -> $(@).data('name') > data.user.name ).first()
      if first.length
        first.before(data.html)
      else
        @container.append(data.html)

  _subscribeLeave: =>
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/users/leave", (data) =>
      @container.find("li[data-id=\"#{data.user.id}\"]").remove()


$ ->
  if room_id = $('.js-room-id').data('roomId')
    QZ.room.init()
    window.FAYE_CLIENT.subscribe "/rooms/#{room_id}/message", (data) ->
      QZ.room.chat.addUserMessage(data.user, data.message, '')

    new Users(room_id, $(".js-room-users"))

