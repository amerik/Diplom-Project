class AddUrlsInProfile < ActiveRecord::Migration
  def change
  	add_column :profiles, :fb_url, :string, :limit => 5000
  	add_column :profiles, :tw_url, :string, :limit => 5000
  	add_column :profiles, :inst_url, :string, :limit => 5000
  end
end
