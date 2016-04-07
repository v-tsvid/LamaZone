class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.integer :discount

      t.timestamps null: false
    end
    add_index :coupons, :code, unique: true
  end
end
