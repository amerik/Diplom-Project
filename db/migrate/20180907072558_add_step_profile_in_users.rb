class AddStepProfileInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :step_profile, :integer, :null => false, :default => 0
  end
end
