class CreateDailyStatistics < ActiveRecord::Migration
  def change
    create_table :daily_statistics do |t|
      t.references :user, index: true
      t.string :locale
      t.date :stats_date
      t.float :fastest_answer
      t.integer :answers_in_a_row
      t.integer :correct_answers

      t.index [:locale, :stats_date, :user_id], :unique => true
    end
  end
end
