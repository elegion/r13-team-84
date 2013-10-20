class RoomsDeamon::RoomWatcher

  FIRST_HINT_DELAY = 10.seconds
  SECOND_HINT_DELAY = 20.seconds
  NEXT_QUESTION_DELAY = 30.seconds

  attr_reader :room, :faye_client, :current_room_question

  delegate :question, to: :current_room_question

  def initialize(room, faye_client)
    @faye_client = faye_client
    @room = room
    update_room_question
  end

  def update_room_question
    self.cancel_timers
    if @current_room_question = room.reload.last_room_question
      self.start_timers
    end
  end

  def questions_channel
    "/rooms/#{room.id}/question"
  end

protected

  def start_timers
    @first_hint_timer = EventMachine::Timer.new(FIRST_HINT_DELAY, method(:first_hint))
    @second_hint_timer = EventMachine::Timer.new(SECOND_HINT_DELAY, method(:second_hint))
    @next_question_timer = EventMachine::Timer.new(NEXT_QUESTION_DELAY, method(:next_question))
  end

  def cancel_timers
    @first_hint_timer.try(:cancel)
    @second_hint_timer.try(:cancel)
    @next_question_timer.try(:cancel)
  end

  def hint_user
    I18n.t('hint_user', locale: room.locale)
  end

  def hint_channel
    "/rooms/#{room.id}/hint"
  end

  def publish_hint(hint)
    faye_client.publish(hint_channel, hint: hint)
  end

  def first_hint
    publish_hint(question.first_hint)
  end

  def second_hint
    publish_hint(question.second_hint)
  end

  def next_question
    room_question = room.next_room_question
    data = room_question.decorate.faye_hash
    faye_client.publish(questions_channel, data)
  end
end
