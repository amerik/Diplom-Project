class CreatePageHelps < ActiveRecord::Migration
  def change
    create_table :page_helps do |t|
    	t.integer :category_id
    end
  end
end
