class AddGoogleUrlInProfiles < ActiveRecord::Migration
  def change
  	add_column :profiles, :google_url, :string, :limit => 5000
  end
end
