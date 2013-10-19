class Room < ActiveRecord::Base

  ROOM_SIZE = 5

  validates :name, uniqueness: true

  has_many :room_questions, dependent: :destroy
  has_many :questions, through: :room_questions
  has_many :users

  def last_room_question
    room_questions.order(:created_at).last
  end

  def next_room_question
    if question = self.next_question
      self.room_questions.create(question: question)
    end
  end

  def self.not_full
    where("users_count <= ?", ROOM_SIZE)
  end

  def self.order_by_users_count
    order('users_count DESC')
  end

  def self.first_not_full
    order_by_users_count.not_full.first_or_create(name: "Room #{Room.count + 1}")
  end

  def join(user)
    users << user
  end

protected

  def next_question
    Question.where.not(id: self.questions).random
  end

end
