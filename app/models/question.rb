class Question < ActiveRecord::Base

  belongs_to :question_category

  has_many :answers, dependent: :destroy
  has_many :room_question, dependent: :destroy

  validates :text, presence: true, uniqueness: true

  scope :random, -> { order('random()').first }

  def valid_answer?(answer)
    self.answers.by_normalized_value(answer).exists?
  end
  
end
