class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
    	t.string :alias, :limit => 300
      t.string :kind, :limit => 100
    end
  end
end
