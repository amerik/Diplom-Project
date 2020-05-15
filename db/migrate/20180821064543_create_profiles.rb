class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.string :first_name, :null => true, :limit => 300
    	t.string :last_name, :null => true, :limit => 100
    	t.string :phone, :null => true, :limit => 50
    	t.references :user
    	t.string :image, :limit => 3000
    end

    add_index :profiles, :user_id
  end
end
