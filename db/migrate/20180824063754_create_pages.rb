class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
    	t.string :name, :limit => 1000
    	t.string :alias, :limit => 1000
    end
  end
end
