class CreateAppoints < ActiveRecord::Migration
  def change
    create_table :appoints do |t|
    	t.references :user
    	t.integer :mentor_id
    	t.integer :moderator_id
      t.timestamps null: false
    end

    add_index :appoints, :user_id
    add_index :appoints, :mentor_id
    add_index :appoints, :moderator_id
  end
end
