class AddLocaleToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :locale, :string
  end
end
