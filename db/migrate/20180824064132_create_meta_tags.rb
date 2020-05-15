class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
    	t.references :attach, :polymorphic => true
    end

    add_index :meta_tags, [:attach_id, :attach_type]
  end
end
