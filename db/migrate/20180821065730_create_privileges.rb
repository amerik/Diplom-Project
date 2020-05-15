class CreatePrivileges < ActiveRecord::Migration
  def change
    create_table :privileges do |t|
    	t.string :page_name, :limit => 100
    	t.string :action_name, :limit => 100
    	t.references :role
    end

    add_index :privileges, :role_id
  end
end
