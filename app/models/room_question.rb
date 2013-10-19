class RoomQuestion < ActiveRecord::Base

  belongs_to :question
  belongs_to :room
  has_many :suggested_answers, dependent: :destroy

  validates :question_id, uniqueness: { scope: :room_id }

end
