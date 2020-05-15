class CreateSpecializations < ActiveRecord::Migration
  def change
    create_table :specializations do |t|
    	t.string :name, :limit => 5000
    	t.string :company, :limit => 5000
    	t.string :industry, :limit => 5000
    	t.string :occupation, :limit => 5000
    	t.references :profile
    end

    add_index :specializations, :profile_id
  end
end
