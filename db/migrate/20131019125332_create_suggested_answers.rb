class CreateSuggestedAnswers < ActiveRecord::Migration
  def change
    create_table :suggested_answers do |t|
      t.string :value
      t.references :user, index: true
      t.references :room_question, index: true

      t.timestamps
    end
  end
end
