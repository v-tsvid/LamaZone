module ActiveTabsHelper
  
  def home_active?
    current_page?(root_path)
  end

  def admin_panel_active?
    current_page?(rails_admin_path)
  end

  def shop_active?
    books_categories_ratings_controller? && !current_page?(root_path)
  end

  def settings_active?
    current_page?(edit_customer_registration_path)
  end

  def orders_active?
    current_page?(orders_path)
  end

  def sign_up_active?
    current_page?(new_customer_registration_path)
  end

  def sign_in_active?
    current_page?(new_customer_session_path)
  end

  def sign_out_active?
    current_page?(destroy_customer_session_path)
  end

  private

    def books_categories_ratings_controller?
      klass = controller.class

      klass == BooksController || klass == CategoriesController || 
      klass == RatingsController
    end
end