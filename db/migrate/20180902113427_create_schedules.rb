class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
    	t.datetime :start_at
    	t.string :kind, :limit => 50
    	t.string :status, :limit => 100
    	t.integer :mentor_id
    	t.references :user
      t.timestamps null: false
    end

    add_index :schedules, :mentor_id
    add_index :schedules, :user_id
  end
end
