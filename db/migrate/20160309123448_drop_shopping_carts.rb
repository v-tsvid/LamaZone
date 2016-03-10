class DropShoppingCarts < ActiveRecord::Migration
  def change
    drop_table :shopping_carts
  end
end
