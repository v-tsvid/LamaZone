class AddBillingAddressRefToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :billing_id, :integer
  end
end
