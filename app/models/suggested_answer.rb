class SuggestedAnswer < ActiveRecord::Base

  belongs_to :user
  belongs_to :room_question

  validates :user_id, :room_question_id, presence: true
  validates :value, presence: true

  before_save :check_valid
  after_save :update_room

  protected

  def check_valid
    self.is_valid = room_question.question.valid_answer?(self.value)
  end

  def update_room
    if self.is_valid?
      room_question.update_attributes(winner_id: self.user_id)
      Rating::update_ratings(room_question.room.users, self.user)
      answer_time = Time.now - room_question.created_at
      answers_in_a_row = 0
      for q in room_question.room.room_questions.order('created_at DESC').offset(1)
        break if q.winner_id != self.user_id
        answers_in_a_row += 1
      end
      DailyStatistics.update_for_user(self.user, room_question.room.locale, answer_time, answers_in_a_row)
    end
  end

end
