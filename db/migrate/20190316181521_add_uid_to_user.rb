class AddUidToUser < ActiveRecord::Migration
  def change
  	add_column :users, :uid, :string, :limit => 100
  	add_column :users, :network, :string, :limit => 500
  end
end
