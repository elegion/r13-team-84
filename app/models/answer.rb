class Answer < ActiveRecord::Base

  belongs_to :question

  validates :value, presence: true, uniqueness: { scope: [ :question_id, :value ] }

end
