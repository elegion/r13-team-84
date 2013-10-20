class DailyStatistics < ActiveRecord::Base
  #t.integer  "user_id"
  #t.string   "locale"
  #t.date     "stats_date"
  #t.float    "fastest_answer"
  #t.integer  "answers_in_a_row"
  #t.integer  "correct_answers"
  #t.datetime "created_at"
  #t.datetime "updated_at"

  belongs_to :user

  validates_uniqueness_of :locale, :scope => [:stats_date, :user_id]

  def self.update_for_user(user, locale, answer_time, answers_in_a_row)
    date = Date.today
    stats = DailyStatistics.find_or_create_by(user: user, locale: locale, stats_date: date) { |s|
      s.answers_in_a_row = answers_in_a_row
      s.fastest_answer = answer_time
      s.correct_answers = 0
    }
    stats.fastest_answer = [stats.fastest_answer, answer_time].min
    stats.answers_in_a_row = [stats.answers_in_a_row, answers_in_a_row].max
    stats.correct_answers += 1
    stats.save!
    stats
  end
end
