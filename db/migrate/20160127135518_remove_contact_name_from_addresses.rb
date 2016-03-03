class RemoveContactNameFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :contact_name
  end
end
