class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :name, :null => false, :default => ''
      t.float :latitude
      t.float :longitude
      t.boolean :privacy_flag, :null => false, :default => true
      t.integer :user_id

      t.timestamps
    end

    add_index :points, :user_id
    add_index :points, :privacy_flag, :unique => false
  end
end
