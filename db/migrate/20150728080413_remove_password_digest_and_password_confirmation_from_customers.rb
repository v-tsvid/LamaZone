class RemovePasswordDigestAndPasswordConfirmationFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :password_digest
    remove_column :customers, :password_confirmation
  end
end
