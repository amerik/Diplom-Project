class AddLanInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :lan, :string, :limit => 5
  end
end
