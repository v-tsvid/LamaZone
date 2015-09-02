require 'features/features_spec_helper'

feature "admin panel customizing" do
  given(:admin) { FactoryGirl.create :admin, 
                  email:                 'admin@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678' }

  background do 
    login_as admin, scope: :admin
    visit rails_admin_path
  end
  
  # {'address' => ['city', 'address1', 'address2'],
  #  'author'  => ['lastname', 'firstname'],
  #  'credit_card' => ['number'],
  #  'customer' => ['lastname', 'firstname'],
  #  'order' => ['book_id'],
  #  'rating' => ['book_id', 'id']}.each do |key, value|
    
  #   @value_str = value.join('+')

  #   scenario "#{key} represents with #{@value_str}" do
  #     obj = FactoryGirl.create key.to_sym
  #     # first(:link, text: "#{key.capitalize.pluralize}").click
  #     first(:css, "a.pjax[href=\"/admin/#{key}\"]").click
  #     find(:css, "a.pjax[href=\"/admin/#{key}/#{obj.id}/edit\"]").click

  #     expect(page).not_to have_content "#{key.capitalize} ##{order.shipping_address.id}"
  #     expect(page).to have_content "#{order.shipping_address.city}" + 
  #     " #{order.shipping_address.address1}" + 
  #     " #{order.shipping_address.address2}"

  #   end
  # end

  context "Database records representing" do
    scenario "Address represents with city+address1+address2" do
      order = FactoryGirl.create :order
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "Address ##{order.shipping_address.id}"
      expect(page).to have_content "#{order.shipping_address.city}" + 
      " #{order.shipping_address.address1}" + 
      " #{order.shipping_address.address2}"
    end

    scenario "Author represents with lastname+firstname" do
      book = FactoryGirl.create :book
      first(:link, text: 'Books').click
      find(:css, "a.pjax[href=\"/admin/book/#{book.id}/edit\"]").click

      expect(page).not_to have_content "Author ##{book.author.id}"
      expect(page).to have_content "#{book.author.lastname}" + 
      " #{book.author.firstname}"
    end

    scenario "Credit card represents with number" do
      order = FactoryGirl.create :order
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "CreditCard ##{order.credit_card.id}"
      expect(page).to have_content "#{order.credit_card.number}"
    end

    scenario "Customer represents with lastname+firstname" do
      order = FactoryGirl.create :order
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "Customer ##{order.customer.id}"
      expect(page).to have_content "#{order.customer.lastname}" + 
      " #{order.customer.firstname}"
    end

    scenario "Order represents with id" do
      credit_card = FactoryGirl.create :credit_card_with_orders
      first(:link, text: 'Credit cards').click
      find(:css, "a.pjax[href=\"/admin/credit_card/#{credit_card.id}/edit\"]").
        click

      expect(page).not_to have_content "Order ##{credit_card.orders.first.id}"
      expect(page).to have_content "#{credit_card.orders.first.id}"
    end

    scenario "Order Item represents with book_title" do
      order = FactoryGirl.create :order_with_order_items
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "OrderItem ##{order.order_items.first.id}"
      expect(page).
        to have_content "#{Book.find(order.order_items.first.book_id).title}"
    end

    scenario "Rating represents with book_id+rating_id" do
      book = FactoryGirl.create :book_with_ratings
      first(:link, text: 'Books').click
      find(:css, "a.pjax[href=\"/admin/book/#{book.id}/edit\"]").click

      expect(page).not_to have_content "Rating ##{book.ratings.first.id}"
      expect(page).to have_content "rating #{book.ratings.first.id}" + 
      " for book #{book.ratings.first.book_id}"
    end
  end
end