class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user
      t.string :provider
      t.string :uid
      t.text :auth
      t.timestamps
    end

    add_index :authentications, [:provider, :uid], unique: true
    add_index :authentications, [:user_id, :provider], unique: true
  end
end
