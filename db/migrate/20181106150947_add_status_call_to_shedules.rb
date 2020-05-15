class AddStatusCallToShedules < ActiveRecord::Migration
  def change
  	add_column :schedules, :status_call, :string, :limit => 50
  end
end
