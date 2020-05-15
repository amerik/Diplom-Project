class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
    	t.string :alias
    	t.string :val_param, :limit => 1000
    end
  end
end
