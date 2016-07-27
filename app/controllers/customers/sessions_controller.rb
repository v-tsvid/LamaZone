class Customers::SessionsController < Devise::SessionsController
  before_action :authenticate_customer!
  after_action :actualize_cart
  
  def new
    if current_admin
      redirect_to(root_path, 
        alert: t("devise.failure.already_authenticated")) and return
    end
    super
  end

  def create
    super
    Order.new(customer: current_customer)
  end
end
