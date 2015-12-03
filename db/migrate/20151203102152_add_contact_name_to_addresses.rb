class AddContactNameToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :contact_name, :string
  end
end
