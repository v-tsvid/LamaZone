class AddOmniauthToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :provider, :string
    add_index :customers, :provider
    add_column :customers, :uid, :string
    add_index :customers, :uid
  end
end
