class AddBillingAddressRefToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :billing_address_id, :integer
  end
end
