class RemoveCustomerIdFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :customer_id
  end
end
