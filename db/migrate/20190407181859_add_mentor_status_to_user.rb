class AddMentorStatusToUser < ActiveRecord::Migration
  def change
  	add_column :users, :mentor_status, :string, :limit => 100
  end
end
