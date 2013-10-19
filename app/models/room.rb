class Room < ActiveRecord::Base

  validates :name, uniqueness: true

  has_many :room_questions, dependent: :destroy
  has_many :questions, through: :room_questions

end
