class AddStatusToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :status, :string, :limit => 100
  end
end

