class RenameColumnShippingIdInTableOrderToShippingAddressId < ActiveRecord::Migration
  def change
    rename_column :orders, :shipping_id, :shipping_address_id
  end
end
