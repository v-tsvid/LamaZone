require 'features/features_spec_helper'

feature "customer's account data viewing" do
  given(:customer) { FactoryGirl.create :customer }
  
  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
                  
    sign_in_via_capybara customer
  end
  
  scenario "view customer's addresses page" do
    visit "/customer/addresses"
    expect(page).to have_content 'My addresses'
  end
  
end