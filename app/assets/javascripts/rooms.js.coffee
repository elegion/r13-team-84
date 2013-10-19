QZ.room = {}

QZ.room.chat =
  _addRawMessage: (html, klass) ->
    $chat = $('.js-room-chat')
    $row = $("<p class='message #{klass}'>#{html}</p>")
    $row.appendTo($chat).hide().fadeIn()
    $chat.stop(true, false).animate({scrollTop: $chat.prop('scrollHeight')})

  addUserMessage: (user, message, klass) ->
    QZ.room.chat._addRawMessage("<strong>#{user}: </strong><span>#{message}</span>", klass)

$ ->
  if room_id = $('.js-room-id').data('roomId')
    $room_questions = $(".js-room-questions")
    window.FAYE_CLIENT.subscribe "/rooms/#{room_id}", (data) ->
      $room_questions.html(data)
