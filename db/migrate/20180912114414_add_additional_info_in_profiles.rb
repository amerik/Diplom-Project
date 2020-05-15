class AddAdditionalInfoInProfiles < ActiveRecord::Migration
  def change
  	add_column :profiles, :additional_info, :text
  end
end
