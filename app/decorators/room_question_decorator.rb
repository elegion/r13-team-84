class RoomQuestionDecorator < Draper::Decorator
  delegate_all

  def faye_hash
    locale = object.room.locale
    {
      html: h.render('rooms/room_question', question: object.question),
      room_question_id: object.id,
    }
  end

end
