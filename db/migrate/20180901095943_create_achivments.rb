class CreateAchivments < ActiveRecord::Migration
  def change
    create_table :achivments do |t|
    	t.string :alias, :limit => 300
    	t.string :image, :limit => 3000
    end
  end
end
