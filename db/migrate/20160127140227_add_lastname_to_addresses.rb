class AddLastnameToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :lastname, :string
  end
end
