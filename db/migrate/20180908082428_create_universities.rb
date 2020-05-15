class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
    	t.string :name
    	t.integer :position, :null => false, :default => 0
    end
  end
end
