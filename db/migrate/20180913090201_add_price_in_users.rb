class AddPriceInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :price, :float, :null => false, :default => 0
  end
end
