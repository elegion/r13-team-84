class Answer < ActiveRecord::Base

  belongs_to :question

  validates :value, :normalized_value, presence: true, uniqueness: { scope: [ :question_id ] }
  validates :question_id, presence: true

  before_validation :push_normalized_value

  def self.by_normalized_value(value)
    where(normalized_value: self.normalize_value(value))
  end

protected

  def self.normalize_value(value)
    value.squish.mb_chars.downcase
  end

  def push_normalized_value
    self.normalized_value = self.class.normalize_value(self.value).to_s
  end

end
