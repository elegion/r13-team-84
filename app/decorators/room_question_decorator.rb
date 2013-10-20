class RoomQuestionDecorator < Draper::Decorator
  delegate_all

  def faye_hash
    {
      html: h.render('rooms/room_question', question: object.question),
      form_url: h.polymorphic_path([ object, SuggestedAnswer.new]),
    }
  end

end
