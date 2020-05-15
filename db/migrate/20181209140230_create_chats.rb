class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
    	t.integer :user_first_id
    	t.integer :user_second_id
      t.timestamps null: false
    end
    add_index :chats, :user_first_id
    add_index :chats, :user_second_id
  end
end
