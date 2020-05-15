class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
    	t.references :attach, :polymorphic => true, :null => false
    	t.string :lan, :null => false, :limit => 10
			t.text :value, :null => true
			t.string :field, :null => false, :limit => 100
    end

    add_index :translations, [:attach_id, :attach_type]
  end
end
