class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
    	t.float :amount, :null => false, :default => 0
    	t.string :status, :limit => 100
      t.timestamps null: false
    end
  end
end
