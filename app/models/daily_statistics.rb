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

  def self.stats_for_date(locale, date)
    {
        fastest_answer: DailyStatistics.where(locale: locale, stats_date: date).order('fastest_answer ASC'),
        answers_in_a_row: DailyStatistics.where(locale: locale, stats_date: date).order('answers_in_a_row DESC'),
        correct_answers: DailyStatistics.where(locale: locale, stats_date: date).order('correct_answers DESC'),
    }
  end

  def self.stats_for_range(locale, from, to)
    {
        fastest_answer: DailyStatistics
          .where(locale: locale).where('stats_date >= ?', from).where('stats_date <= ?', to)
          .select("#{DailyStatistics.table_name}.*, MIN(fastest_answer) AS fa")
          .order('fastest_answer ASC').group(:user_id),
        answers_in_a_row: DailyStatistics
          .where(locale: locale).where('stats_date >= ?', from).where('stats_date <= ?', to)
          .select("#{DailyStatistics.table_name}.*, MAX(answers_in_a_row) AS answers_in_a_row")
          .order('answers_in_a_row DESC').group(:user_id),
        correct_answers: DailyStatistics
          .where(locale: locale).where('stats_date >= ?', from).where('stats_date <= ?', to)
          .select("#{DailyStatistics.table_name}.*, SUM(correct_answers) AS correct_answers, SUM(correct_answers) AS correct_answers_sum")
          .order('correct_answers_sum DESC').group(:user_id),
    }
  end
end
