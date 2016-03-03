class RenameShippingAddresIdInCustomersToShippingAddressId < ActiveRecord::Migration
  def change
    rename_column :customers, :shipping_addres_id, :shipping_address_id
  end
end
