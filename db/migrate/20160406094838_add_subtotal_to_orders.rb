class AddSubtotalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :subtotal, :decimal
  end
end
