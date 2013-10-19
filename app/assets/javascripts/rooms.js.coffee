$ ->
  if room_id = $('.js-room-id').data('roomId')
    $room_questions = $(".js-room-questions")
    window.FAYE_CLIENT.subscribe "/rooms/#{room_id}", (data) ->
      $room_questions.html(data)
