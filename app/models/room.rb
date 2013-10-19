class Room < ActiveRecord::Base

  validates :name, uniqueness: true

  has_many :room_questions, dependent: :destroy
  has_many :questions, through: :room_questions

  def last_room_question
    room_questions.order(:created_at).last
  end

  def next_room_question
    if question = self.next_question
      self.room_questions.create(question: question)
    end
  end

  def full?
    self.created_at < 1.minute.ago
  end

protected

  def next_question
    Question.where.not(id: self.questions).random
  end

end
