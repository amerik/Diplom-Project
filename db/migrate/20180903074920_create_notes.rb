class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
    	t.references :schedule
    	t.string :name, :limit => 3000
    	t.text :description
      t.timestamps null: false
    end

    add_index :notes, :schedule_id
  end
end
