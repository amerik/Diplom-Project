class RemoveUserFromVideos < ActiveRecord::Migration
  def change
  	remove_column :videos, :user_id
  end
end
