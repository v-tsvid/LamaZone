class Customers::SessionsController < Devise::SessionsController
  before_action :authenticate_customer!

  def create
    super
    Order.new(customer: current_customer)
  end
end
