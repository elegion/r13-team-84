QZ.room =
  init: ->
    @container = $('.js-room-container')
    @room_id = @container.data('roomId')
    return unless @room_id
    new ChatLog(@room_id, @container.find('.js-room-chatlog'))
    new Users(@room_id, @container.find('.js-room-users'))
    form = new Form(@room_id, @container.find('.js-room-message-form'))
    new CurrentQuestion(@room_id, @container.find('.js-room-question'), form)
    new CurrentQuestionHint(@room_id)


class ChatLog
  constructor: (@room_id, @container) ->
    @container.scroll(@_onChatScroll)
    @_subscribe()

  _subscribe: ->
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/message", (data) =>
      @addRawMessage(data.html)

  _onChatScroll: (event) =>

  addRawMessage: (html) ->
    $row = $(html)
    $row.appendTo(@container).hide().fadeIn()
    @container.stop(true, false).animate({scrollTop: @container.prop('scrollHeight')})


class CurrentQuestion
  constructor: (@room_id, @container, @form) ->
    @_subscribe()

  _subscribe: ->
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/question", (data) =>
      @_update(data)

  _update: (data) ->
    @container.html(data.html)
    @form.updateRoomQuestionId(data.room_question_id)


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


class Form
  constructor: (@room_id, @form) ->
    @input = @form.find('.js-room-message-form-message')
    @form.on 'ajax:beforeSend', (evt, xhr, settings) =>
      return false unless @input.val().length
      @input.val('')
      true

  updateRoomQuestionId: (roomQuestionId) ->
    @form.find('.js-room-question-id').val()

class CurrentQuestionHint
  constructor: (@room_id) ->
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/hint", @updateHint

  updateHint: (data) ->
    $('.js-hint').text(data.hint)


$ -> QZ.room.init()
