class AddStateDefaultValueToOrders < ActiveRecord::Migration
  def up
    change_column_default :orders, :state, 0
  end

  def down
    change_column_default :orders, :state, nil
  end
end
