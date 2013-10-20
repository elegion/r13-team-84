class AddLocaleToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :locale, :string
    add_index :questions, :locale
  end
end
