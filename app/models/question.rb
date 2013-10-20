class Question < ActiveRecord::Base
  HINT_MASK_CHAR = '*'

  belongs_to :question_category

  has_many :answers, dependent: :destroy
  has_many :room_question, dependent: :destroy

  validates :text, presence: true, uniqueness: true

  def valid_answer?(answer)
    self.answers.by_normalized_value(answer).exists?
  end

  def first_hint
    self.answer_hint_mask(1)
  end

  def second_hint
    self.answer_hint_mask(3)
  end

  def answer
    self.answers.first.value
  end

protected

  def answer_hint_mask(visible_chars)
    mash_chars = HINT_MASK_CHAR * (self.answer.length - visible_chars)
    self.answer.first(visible_chars) + mash_chars
  end

end
