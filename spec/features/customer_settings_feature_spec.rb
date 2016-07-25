require 'features/features_spec_helper'

feature "settings of authorized customer" do
  let(:current_password) { '12345678' }
  let(:bil_address) { FactoryGirl.create(:address, 
    firstname: 'name1', lastname: 'name2') }
  let(:ship_address) { FactoryGirl.create(:address, 
    firstname: 'name3', lastname: 'name4') }
  
  let(:customer) { FactoryGirl.create :customer, 
                   email:                 'customer@mail.com', 
                   password:              current_password,
                   password_confirmation: current_password,
                   billing_address:       bil_address,
                   shipping_address:      ship_address }
  
  let(:book) { FactoryGirl.build_stubbed :book }

  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
      
    allow(Book).to receive(:of_category).with('bestsellers').
      and_return [book]
                  
    login_as customer
  end

  scenario "visit settings page" do
    visit edit_customer_registration_path
    expect(page).to have_selector('h3', text: t("settings_page.settings"))
  end

  background { visit edit_customer_registration_path }

  [:billing_address, :shipping_address].each do |item|
    scenario "see own #{spaced(item)} on the settings page" do
      expect(page).to have_selector(
        "input[value='#{customer.public_send(item).firstname}']")
      expect(page).to have_selector(
        "input[value='#{customer.public_send(item).lastname}']")
    end

    scenario "edit own #{spaced(item)} on the settings page" do
      new_name = "new" + customer.send(item).firstname
      
      within(".#{item.to_s}_form") do
        fill_in 'address_firstname', with: new_name
        click_button t("settings_page.save")
      end
      expect(page).to have_text t("controllers.address_updated")
    end 
  end
  
  context "when authorized without omniauth" do
     let(:customer) { FactoryGirl.create :customer, 
                   email:                 'customer@mail.com', 
                   password:              current_password,
                   password_confirmation: current_password,
                   billing_address:       bil_address,
                   shipping_address:      ship_address,
                   uid:                   nil }

    [:email, :password].each do |item|
      scenario "edit own #{spaced(item)}" do
        within(".#{item.to_s}_form") do
          new_param = item == :email ? 'new@mail.com' : 'newpassword'
          if item == :email
            fill_in 'customer_email', with: new_param
          else
            fill_in 'customer_current_password', with: current_password
            fill_in 'customer_password', with: new_param
          end
          click_button t("settings_page.save")
        end
        expect(page).to have_text t("devise.registrations.updated")
      end
    end
  end

  context "when authorized with omniauth" do
    
    [t("settings_page.email_caption"), 
     t("settings_page.password")].each do |item|
      scenario "doesn't see #{item} form" do
        expect(page).not_to have_content item
      end
    end
  end

  scenario "remove own account" do
    find(:css, "#confirm").set(true)   
    click_button t("settings_page.remove_acc_button")
    expect(page).to have_text t("devise.registrations.destroyed")
  end
end