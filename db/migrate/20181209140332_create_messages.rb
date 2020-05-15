class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.integer :user_id
    	t.integer :user_sender_id
    	t.integer :chat_id
    	t.text :description
      t.timestamps null: false
    end
    add_index :messages, :user_id
    add_index :messages, :user_sender_id
    add_index :messages, :chat_id
  end
end
