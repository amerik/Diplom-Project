class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
    	t.string :name, :limit => 3000
    	t.text :description
    end
  end
end
