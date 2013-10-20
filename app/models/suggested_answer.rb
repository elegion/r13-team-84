class SuggestedAnswer < ActiveRecord::Base

  belongs_to :user
  belongs_to :room_question

  validates :user_id, :room_question_id, presence: true
  validates :value, presence: true

  after_save :check_value

  protected

  def check_value
    if room_question.question.valid_answer?(self.value)
      room_question.update_attributes(winner_id: self.user_id)
      Rating::update_ratings(room_question.room.users, self.user)
    end
  end

end
