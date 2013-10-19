class CreateRoomQuestions < ActiveRecord::Migration
  def change
    create_table :room_questions do |t|
      t.references :question, index: true, null: false
      t.references :room, index: true, null: false
      t.references :winner, index: true

      t.timestamps

      t.index [ :question_id, :room_id ], unique: true
    end
  end
end
