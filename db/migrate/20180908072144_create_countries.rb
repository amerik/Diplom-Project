class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
    	t.string :name_rus
    	t.string :name_en
    	t.string :flag
    end
  end
end
