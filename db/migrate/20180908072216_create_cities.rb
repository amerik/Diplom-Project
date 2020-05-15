class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
    	t.string :name_rus
    	t.string :name_en
    	t.references :country
    end

    add_index :cities, :country_id
  end
end
