class RoomQuestion < ActiveRecord::Base

  belongs_to :question
  belongs_to :room
  belongs_to :winner, class_name: 'User'
  has_many :suggested_answers, dependent: :destroy

  after_save :next_room_question, if: :winner_id_changed?

  protected

  def next_room_question
    self.room.next_room_question
  end

end
