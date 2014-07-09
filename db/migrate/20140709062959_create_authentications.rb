class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider, :null => false, :default => ''
      t.string :uid, :null => false, :default => ''
      t.string :name, :null => false, :default => ''
      t.string :email, :null => false, :default => ''
      t.integer :user_id

      t.timestamps
    end

    add_index :authentications, :provider, :unique => false
    add_index :authentications, :user_id
  end
end
