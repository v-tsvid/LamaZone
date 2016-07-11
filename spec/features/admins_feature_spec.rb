require 'features/features_spec_helper'

feature "access to admin panel" do 
  given(:admin) { FactoryGirl.create :admin, 
                  email:                 'admin@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678' }



  background do
    @book = FactoryGirl.build_stubbed :book
    allow(Book).to receive(:of_category).with('bestsellers').
      and_return [@book]
    
    login_as admin, scope: :admin
  end

  scenario "has a link to admin panel" do
    visit root_path
    expect(page).to have_link t(:admin_panel)
  end
  
  scenario "gets an access to admin panel" do
    visit rails_admin_path
    expect(page).to have_content 'Dashboard'
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

  context "database records representing" do
    
    ['address', 
     'author', 
     'credit_card', 
     'customer', 
     'order', 
     'order_item', 
     'rating'].each do |str|
      scenario "#{str.humanize.downcase} represents with custom_label_method" do
        item = FactoryGirl.create str.to_sym
        first(:link, text: str.humanize.pluralize).click
        find(:css, admin_panel_edit_link("#{str}/#{item.id}")).click

        expect(page).to have_content(
          "Edit #{str.humanize} '#{item.custom_label_method}'")
      end
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
   'Coupons',
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
    find(:css, admin_panel_edit_link("order/#{order.id}")).click
    find("option[value='canceled']").click
    find("button[name='_save']").click
    expect(page).to have_content "Order successfully updated"
  end

  scenario "allowed to change rating states" do
    rating = FactoryGirl.create :rating, state: "pending"
    first(:link, text: 'Ratings').click
    find(:css, admin_panel_edit_link("rating/#{rating.id}")).click
    find("option[value='approved']").click
    find("button[name='_save']").click
    expect(page).to have_content "Rating successfully updated"
  end
end