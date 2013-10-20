class QuestionCategory < ActiveRecord::Base

  has_many :questions, dependent: :nullify

  validates :name, presence: true, uniqueness: true

end
