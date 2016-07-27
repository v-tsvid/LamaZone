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
    
    ['author', 
     'order', 
     'rating'].each do |str|
      scenario "#{str.humanize.downcase} represents with custom_label_method" do
        item = FactoryGirl.create str.to_sym
        first(:link, text: str.humanize.pluralize).click
        find(:css, admin_panel_show_link("#{str}/#{item.id}")).click

        expect(page).to have_content(
          "Details for #{str.humanize} '#{item.custom_label_method}'")
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
  
  ['Admins', 
   'Authors', 
   'Books', 
   'Categories',
   'Coupons',
   'Orders',
   'Ratings'].each do |item|
    scenario "allowed to crud #{item}" do
      expect(page).to have_link item
    end
  end

  context "custom actions" do
    context "ratings" do
      let!(:rating) { FactoryGirl.create :rating, state: "pending" }
      let!(:str) { "rating/#{rating.id}" }
      
      before do 
        first(:link, text: 'Ratings').click
      end

      ['approve', 'reject'].each do |item|
        scenario "allowed to #{item} ratings" do  
          first(
            :css, admin_panel_custom_action_link(str, "#{item}_rating")).click

          expect(page).to have_content "You have #{item}"
        end
      end
    end
    
    context "orders" do
      let!(:order) { FactoryGirl.create :order, state: "processing" }
      let!(:str) { "order/#{order.id}" }

      before do 
        first(:link, text: 'Orders').click
      end

      ['complete', 'cancel', 'ship'].each do |item|
        scenario "allowed to #{item} orders" do
          first(
            :css, admin_panel_custom_action_link(str, "#{item}_order")).click
          expect(page).to have_content "You have "
          expect(page).to have_content "item"
        end
      end
    end
  end
end