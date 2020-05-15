class AddStatusInAppoints < ActiveRecord::Migration
  def change
  	add_column :appoints, :status, :string, :limit => 100
  end
end
