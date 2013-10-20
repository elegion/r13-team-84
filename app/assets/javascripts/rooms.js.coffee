QZ.room =
  init: ->
    @container = $('.js-room-container')
    @room_id = @container.data('roomId')
    return unless @room_id
    @chatlog = new ChatLog(@room_id, @container.find('.js-room-chatlog'))
    @users = new Users(@room_id, @container.find('.js-room-users'))
    @form = new Form(@room_id, @container.find('.js-room-message-form'))
    @question = new CurrentQuestion(@room_id, @container.find('.js-room-question'))
    @hint = new CurrentQuestionHint(@room_id)
    @questions_over = new QuestionsOver(@container)
    @_subscribe()

  _subscribe: ->
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/question", (data) =>
      @questions_over.toggle(!!data)
      if data
        @chatlog.newQuestion(data)
        @question.update(data)
        @form.updateRoomQuestionId(data.room_question_id)

class ChatLog
  constructor: (@room_id, @container) ->
    @_subscribe()
    @container.scroll(@_onChatScroll)
    @scrollToBottom()

  _subscribe: ->
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/message", (data) =>
      @addRawMessage(data.html)

  _onChatScroll: (event) =>
    c = @container[0]
    is_bottom = c.scrollTop + c.offsetHeight >= c.scrollHeight
    evt = 'newMessage.scroll'
    if is_bottom
      @container.on(evt, => @scrollToBottom())
    else
      @container.off(evt)

  addRawMessage: (html) ->
    $row = $(html)
    $row.appendTo(@container).hide().fadeIn()
    @container.trigger('newMessage')

  scrollToBottom: ->
    @container.stop(true).animate(scrollTop: @container.prop('scrollHeight'))

  newQuestion: (data) ->
    @addRawMessage(data.html)


class CurrentQuestion
  constructor: (@room_id, @container) ->

  update: (data) ->
    @container.html(data.html)


class CurrentQuestionHint
  constructor: (@room_id) ->
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/hint", @updateHint

  updateHint: (data) ->
    $('.js-hint').text(data.hint)


class Users
  constructor: (@room_id, @container) ->
    @_subscribeChannels()

  _subscribeChannels: =>
    @_subscribeJoin()
    @_subscribeLeave()
    @_subscribeRatings()

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

  _subscribeRatings: =>
    window.FAYE_CLIENT.subscribe "/rooms/#{@room_id}/users/ratings", (data) =>
      for user in data.users
        $user = @container.find("li[data-id=\"#{user.id}\"]")
        $rating = $user.find('.js-user-rating')
        @_animateRatingChange($rating, user.rating)

  _animateRatingChange: ($rating, to) =>
    from = parseFloat($rating.html()[1..-1])
    $({rating: from}).animate({rating: to},
      step: ->
        value = Math.round(@rating * 10) / 10
        $rating.html("(#{value})")
    )


class Form
  constructor: (@room_id, @form) ->
    @input = @form.find('.js-room-message-form-message')
    @form.on 'ajax:beforeSend', (evt, xhr, settings) =>
      return false unless @input.val().length
      @input.val('')
      true

  updateRoomQuestionId: (roomQuestionId) ->
    @form.find('.js-room-question-id').val(roomQuestionId)

class QuestionsOver
  constructor: (container) ->
    @suggestedAnswerForm = container.find('.js-suggested-answer-form')
    @roomQuestion = container.find('.js-room-question')
    @questionsOver = container.find('.js-questions-over')

  toggle: (form_visible) ->
    @suggestedAnswerForm.toggleClass('hide', !form_visible)
    @roomQuestion.toggleClass('hide', !form_visible)
    @questionsOver.toggleClass('hide', form_visible)


$ -> QZ.room.init()
