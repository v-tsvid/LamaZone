class RenameColumnPasswordInTableCustomerToPasswordDigest < ActiveRecord::Migration
  def change
    rename_column :customers, :password, :password_digest
  end
end
