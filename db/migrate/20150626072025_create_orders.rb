class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :state
      t.decimal :total_price
      t.date :completed_date

      t.timestamps null: false
    end
  end
end
