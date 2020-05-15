class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
    	t.references :user
      t.timestamps null: false
    end
    add_index :videos, :user_id
  end
end
