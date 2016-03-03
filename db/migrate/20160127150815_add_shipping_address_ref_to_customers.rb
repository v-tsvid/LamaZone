class AddShippingAddressRefToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :shipping_addres_id, :integer
  end
end
