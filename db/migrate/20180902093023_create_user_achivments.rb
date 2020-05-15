class CreateUserAchivments < ActiveRecord::Migration
  def change
    create_table :user_achivments do |t|
    	t.references :user
    	t.references :achivment
    	t.text :description
      t.timestamps null: false
    end

    add_index :user_achivments, :user_id
    add_index :user_achivments, :achivment_id
  end
end
