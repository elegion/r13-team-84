class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :text, null: false
      t.references :question_category, index: true

      t.timestamps

      t.index :text, unique: true
    end
  end
end
