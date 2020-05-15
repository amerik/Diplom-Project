class AddCountryToProfile < ActiveRecord::Migration
  def change
  	add_column :profiles, :country_id, :integer
  	add_index :profiles, :country_id
  end
end
