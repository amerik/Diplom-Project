class AddStatusToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :status, :string, :limit => 50
  end
end
