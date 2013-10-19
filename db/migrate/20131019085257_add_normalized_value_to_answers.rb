class AddNormalizedValueToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :normalized_value, :string
    add_index :answers, [ :question_id, :normalized_value ], unique: true
  end
end
