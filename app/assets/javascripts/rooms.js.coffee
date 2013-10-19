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
      @container.append(@_renderUser(data))

  _subscribeLeave: =>
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/users/leave", (data) =>
      @container.find("a[data-id=\"#{data.user.id}\"]").closest('li').remove()

  _renderUser: (data) ->
    $('<li>',
      'html': $('<a>'
        'class': 'js-user-link',
        'href': data.user_link,
        'text': data.user.name,
        'data': {
          'id': data.user.id
        }
      )
    )


$ ->
  if room_id = $('.js-room-id').data('roomId')
    QZ.room.init()
    window.FAYE_CLIENT.subscribe "/rooms/#{room_id}/message", (data) ->
      QZ.room.chat.addUserMessage(data.user, data.message, '')

    new Users(room_id, $(".js-room-users"))

