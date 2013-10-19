class AddIndexToRoomUsersCount < ActiveRecord::Migration
  def change
    add_index :rooms, :users_count
  end
end
