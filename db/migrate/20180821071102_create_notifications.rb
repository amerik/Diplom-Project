class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.string :kind, :limit => 100
    	t.text :description
    	t.string :status, :limit => 100
    	t.references :user
      t.timestamps null: false
      t.string :name, :limit => 5000
      t.string :role, :limit => 100
    end

    add_index :notifications, :user_id
  end
end
