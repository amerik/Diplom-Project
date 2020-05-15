class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
    	t.string :image, :limit => 3000
      t.integer :position, :null => false, :default => 0
    end
  end
end
