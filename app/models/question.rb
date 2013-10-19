class Question < ActiveRecord::Base

  belongs_to :question_category

  has_many :answers, dependent: :destroy
  has_many :room_question, dependent: :destroy

  validates :text, presence: true, uniqueness: true
  
end
