class Room < ActiveRecord::Base

  ROOM_SIZE = 5

  validates :name, uniqueness: true

  has_many :room_questions, dependent: :destroy
  has_many :questions, through: :room_questions
  has_many :users

  after_create :next_room_question

  def last_room_question
    room_questions.order(:created_at).last
  end

  def next_room_question
    if question = self.next_question
      self.room_questions.create(question: question)
    end
  end

  def self.not_full
    where('users_count < ?', ROOM_SIZE)
  end

  def self.questions_not_over
    joins(:room_questions).where(room_questions: {winner_id: nil})
  end

  def self.order_by_users_count
    order('users_count DESC')
  end

  def self.by_locale
    where('locale = ?', I18n.locale)
  end

  def self.first_not_full
    by_locale.order_by_users_count.not_full.questions_not_over.first_or_create(
      name: "#{I18n.t('rooms.prefix')} #{Room.count + 1}",
      locale: I18n.locale
    )
  end

  def questions_over?
    last_room_question.winner_id?
  end

  protected

  def next_question
    offset = rand(Question.where(locale: locale).count)
    Question.where(locale: locale).first(offset: offset)
  end

end
