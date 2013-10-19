class RoomQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :room

  validates :question_id, uniqueness: { scope: :room_id }
end
