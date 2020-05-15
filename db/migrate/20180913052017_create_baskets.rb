class CreateBaskets < ActiveRecord::Migration
  def change
    create_table :baskets do |t|
    	t.references :user
    	t.references :schedule
    	t.references :payment
    	t.string :status, :limit => 100
      t.timestamps null: false
    end

    add_index :baskets, :user_id
    add_index :baskets, :schedule_id
    add_index :baskets, :payment_id
  end
end
