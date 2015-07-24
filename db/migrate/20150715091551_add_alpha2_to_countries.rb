class AddAlpha2ToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :alpha2, :string
  end
end
