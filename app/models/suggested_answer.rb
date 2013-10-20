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
    end
  end

end
