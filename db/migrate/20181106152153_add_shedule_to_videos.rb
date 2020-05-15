class AddSheduleToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :schedule_id, :integer
  end
end
