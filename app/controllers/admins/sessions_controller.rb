class Admins::SessionsController < Devise::SessionsController

  def new
    if current_customer
      redirect_to(root_path, 
        alert: t("devise.failure.already_authenticated")) and return
    end
    super
  end
end
