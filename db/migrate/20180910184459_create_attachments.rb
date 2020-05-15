class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
    	t.string :file, :limit => 200, :null => false
    	t.references :attachable, :polymorphic => true, :null => true
    	t.references :user, :null => true
    	t.string :kind, :limit => 200, :null => true
      t.timestamps
    end

    add_index :attachments, :user_id
  end
end
