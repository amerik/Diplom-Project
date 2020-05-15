class AddIsMentorVerificationInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_mentor_verification, :boolean, :null => false, :default => false
  end
end
