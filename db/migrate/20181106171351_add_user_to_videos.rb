class AddUserToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :user_id, :integer
  	add_column :videos, :file, :string, :limit => 100
  end
end
