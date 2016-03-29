class AddNextStepToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :next_step, :string
  end
end
