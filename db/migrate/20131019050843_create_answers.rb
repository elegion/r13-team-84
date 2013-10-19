class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :value, null: false
      t.references :question

      t.timestamps

      t.index [ :question_id, :value ], unique: true
    end
  end
end
