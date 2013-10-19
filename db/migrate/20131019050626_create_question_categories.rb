class CreateQuestionCategories < ActiveRecord::Migration
  def change
    create_table :question_categories do |t|
      t.string :name, null: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
