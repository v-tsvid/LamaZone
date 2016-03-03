class AddFirstnameToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :firstname, :string
  end
end
