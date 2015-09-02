# require 'rails_helper'

# RSpec.describe "orders/edit", type: :view do
#   before(:each) do
#     @order = assign(:order, Order.create!(
#       :state => 1,
#       :total_price => "9.99",
#       :completed_date => Date.today.next_day,
#       :created_at => DateTime.now
#     ))
#   end

#   it "renders the edit order form" do
#     render

#     assert_select "form[action=?][method=?]", order_path(@order), "post" do

#       assert_select "input#order_state[name=?]", "order[state]"

#       assert_select "input#order_total_price[name=?]", "order[total_price]"
#     end
#   end
# end
