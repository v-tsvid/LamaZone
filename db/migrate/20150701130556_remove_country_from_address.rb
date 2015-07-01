class RemoveCountryFromAddress < ActiveRecord::Migration
  def change
    remove_column :addresses, :country, :string
  end
end
