class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    	t.references :schedule
    	t.references :achivment
    	t.string :status, :limit => 100
    	t.text :description
      t.timestamps null: false
    end

    add_index :tasks, :schedule_id
    add_index :tasks, :achivment_id

    add_column :user_achivments, :task_id, :integer
    add_index :user_achivments, :task_id
  end
end
