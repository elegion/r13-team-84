class AddIsValidToSuggestedAnswer < ActiveRecord::Migration
  def change
    add_column :suggested_answers, :is_valid, :boolean
  end
end
