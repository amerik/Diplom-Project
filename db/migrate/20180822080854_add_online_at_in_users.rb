class AddOnlineAtInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :online_at, :datetime
  end
end
