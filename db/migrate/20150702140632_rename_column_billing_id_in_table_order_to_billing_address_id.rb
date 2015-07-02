class RenameColumnBillingIdInTableOrderToBillingAddressId < ActiveRecord::Migration
  def change
    rename_column :orders, :billing_id, :billing_address_id
  end
end
