class DropShoppingCartItems < ActiveRecord::Migration
  def change
    drop_table :shopping_cart_items
  end
end
