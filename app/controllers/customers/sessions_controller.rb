class Customers::SessionsController < Devise::SessionsController
  before_action :authenticate_customer!
  after_action :actualize_cart, only: :create

  def create
    super
    Order.new(customer: current_customer)
  end
end
