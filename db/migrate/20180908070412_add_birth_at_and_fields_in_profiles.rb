class AddBirthAtAndFieldsInProfiles < ActiveRecord::Migration
  def change
  	add_column :profiles, :birth_at, :date
  	add_column :profiles, :city_id, :integer
  	add_column :profiles, :sex, :string, :limit => 10
  	add_column :profiles, :university_id, :integer
  	add_column :profiles, :degree, :string, :limit => 5000
  	add_column :profiles, :year_of_study, :string, :limit => 500
  	add_column :profiles, :motivational_letter, :text
  	add_column :profiles, :time_preference, :string, :limit => 100
  	add_column :profiles, :price_preference, :string, :limit => 100
  	add_column :profiles, :about_my, :text

  	add_index :profiles, :city_id
  	add_index :profiles, :university_id
  end
end
