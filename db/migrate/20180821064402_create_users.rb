class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :login, :null => false, :limit => 100
    	t.string :salt, :null => false, :limit => 150
    	t.string :password, :null => false, :limit => 150
    	t.string :access_token, :null => false, :limit => 150
    	t.string :code_register, :null => true, :limit => 150
    	t.boolean :status_register, :null => false, :default => false
    	t.string :role_kind, :null => false, :limit => 150
      t.timestamps null: false
    end
  end
end
