require 'features/features_spec_helper'

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
    order = FactoryGirl.create :order, state: "in_queue"
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