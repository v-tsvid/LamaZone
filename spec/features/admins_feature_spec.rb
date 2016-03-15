require 'features/features_spec_helper'

feature "access to admin panel" do 
  given(:admin) { FactoryGirl.create :admin, 
                  email:                 'admin@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678' }


  context "signed in admin" do
    background { login_as admin, scope: :admin }

    # scenario "has a link to admin panel" do
    #   visit root_path

    #   expect(page).to have_link 'Admin Panel'
    # end
    
    # scenario "gets an access to admin panel" do
    #   visit rails_admin_path

    #   expect(page).to have_content 'Dashboard'
    # end   
  end

  context "unsigned in user" do
    background do
      logout admin
    end

    # scenario "has no link to admin panel" do
    #   visit root_path

    #   expect(page).not_to have_link 'Admin Panel'
    # end
    
    # scenario "does not get access to admin panel" do
    #   visit rails_admin_path

    #   expect(page).not_to have_content 'Dashboard'
    # end
  end
end

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

  context "database records representing" do
    scenario "address represents with city+address1+address2" do
      order = FactoryGirl.create :order
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "Address ##{order.shipping_address.id}"
      expect(page).to have_content "#{order.shipping_address.city}" + 
      " #{order.shipping_address.address1}" + 
      " #{order.shipping_address.address2}"
    end

    scenario "author represents with lastname+firstname" do
      book = FactoryGirl.create :book
      first(:link, text: 'Books').click
      find(:css, "a.pjax[href=\"/admin/book/#{book.id}/edit\"]").click

      expect(page).not_to have_content "Author ##{book.author.id}"
      expect(page).to have_content "#{book.author.lastname}" + 
      " #{book.author.firstname}"
    end

    scenario "credit card represents with number" do
      order = FactoryGirl.create :order
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "CreditCard ##{order.credit_card.id}"
      expect(page).to have_content "#{order.credit_card.number}"
    end

    scenario "customer represents with lastname+firstname" do
      order = FactoryGirl.create :order
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "Customer ##{order.customer.id}"
      expect(page).to have_content "#{order.customer.lastname}" + 
      " #{order.customer.firstname}"
    end

    scenario "order represents with id" do
      credit_card = FactoryGirl.create :credit_card_with_orders
      first(:link, text: 'Credit cards').click
      find(:css, "a.pjax[href=\"/admin/credit_card/#{credit_card.id}/edit\"]").
        click

      expect(page).not_to have_content "Order ##{credit_card.orders.first.id}"
      expect(page).to have_content "#{credit_card.orders.first.id}"
    end

    scenario "order item represents with book_title" do
      order = FactoryGirl.create :order_with_order_items
      first(:link, text: 'Orders').click
      find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click

      expect(page).not_to have_content "OrderItem ##{order.order_items.first.id}"
      expect(page).
        to have_content "#{Book.find(order.order_items.first.book_id).title}"
    end

    scenario "rating represents with book_id+rating_id" do
      book = FactoryGirl.create :book_with_ratings
      first(:link, text: 'Books').click
      find(:css, "a.pjax[href=\"/admin/book/#{book.id}/edit\"]").click

      expect(page).not_to have_content "Rating ##{book.ratings.first.id}"
      expect(page).to have_content "rating #{book.ratings.first.id}" + 
      " for book #{book.ratings.first.book_id}"
    end
  end
end

feature "data management with admin panel" do 
  given(:admin) { FactoryGirl.create :admin, 
                  email:                 'admin@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678' }

  background do
    login_as admin, scope: :admin
    visit rails_admin_path
  end
  
  ['Addresses', 
   'Admins', 
   'Authors', 
   'Books', 
   'Categories',
   'Countries',
   'Credit cards',
   'Customers',
   'Order items', 
   'Orders',
   'Ratings'].each do |item|
    scenario "allowed to crud #{item}" do
      expect(page).to have_link item
    end
  end

  scenario "allowed to change order states" do
    order = FactoryGirl.create :order, state: "processing"
    first(:link, text: 'Orders').click
    find(:css, "a.pjax[href=\"/admin/order/#{order.id}/edit\"]").click
    find("option[value='canceled']").click
    find("button[name='_save']").click
    expect(page).to have_content "Order successfully updated"
  end

  scenario "allowed to change rating states" do
    rating = FactoryGirl.create :rating, state: "pending"
    first(:link, text: 'Ratings').click
    find(:css, "a.pjax[href=\"/admin/rating/#{rating.id}/edit\"]").click
    find("option[value='approved']").click
    find("button[name='_save']").click
    expect(page).to have_content "Rating successfully updated"
  end
end