class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zipcode
      t.string :country

      t.timestamps null: false
    end
  end
end
