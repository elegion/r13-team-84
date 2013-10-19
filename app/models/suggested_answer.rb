class SuggestedAnswer < ActiveRecord::Base

  belongs_to :user
  belongs_to :room_question

  validates :user_id, :room_question_id, presence: true
  validates :value, presence: true

end
