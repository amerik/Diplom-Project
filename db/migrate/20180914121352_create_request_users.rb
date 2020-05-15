class CreateRequestUsers < ActiveRecord::Migration
  def change
    create_table :request_users do |t|
    	t.string :email, :limit => 300
      t.timestamps null: false
    end
  end
end
