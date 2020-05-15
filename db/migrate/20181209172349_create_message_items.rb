class CreateMessageItems < ActiveRecord::Migration
  def change
    create_table :message_items do |t|
    	t.references :message
    	t.string :image, :limit => 3000
      t.timestamps null: false
    end
    add_index :message_items, :message_id
  end
end
