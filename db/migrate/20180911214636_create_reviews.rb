class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
    	t.string :image, :limit => 3000
      t.integer :position, :null => false, :default => 0
    end
  end
end
