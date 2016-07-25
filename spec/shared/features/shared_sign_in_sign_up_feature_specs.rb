shared_context "bestseller book creation" do
  background { FactoryGirl.create :bestseller_book }
end

shared_examples 'sign in or sign up via Facebook' do

  background do
    correct_customer = Customer.find_by(email: 'vad_1989@mail.ru')
    correct_customer.destroy if correct_customer
  end

  given(:fb_customer) {
    FactoryGirl.build(:customer, firstname: "Vadim", lastname: "Tsvid",
                      email: 'vad_1989@mail.ru', password: '12345678',
                      password_confirmation: '12345678',
                      provider: "facebook", uid: "580001345483302") }

  given(:link_to_click) { "/customers/auth/facebook" }
   
  scenario "successfully sign in with Facebook profile of exisitng user" do
    fb_customer.save
    valid_facebook_sign_in
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    find(:css, "a[href=\"#{link_to_click}\"]").click

    expect(page).
      to have_content t("devise.omniauth_callbacks.success", kind: 'Facebook')
  end

  scenario "successfully sign up with Facebook profile of unexisitng user" do
    valid_facebook_sign_in
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    find(:css, "a[href=\"#{link_to_click}\"]").click

    expect(page).
      to have_content t("devise.omniauth_callbacks.success", kind: 'Facebook')
  end

  scenario "successfully sign up when email was not fetched from Facebook" do
    valid_facebook_sign_in
    OmniAuth.config.mock_auth[:facebook].info.email = nil
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    find(:css, "a[href=\"#{link_to_click}\"]").click

    expect(page).
      to have_content t("devise.omniauth_callbacks.success", kind: 'Facebook')
  end

  scenario "failed to sign in with invalid credentials" do
    invalid_facebook_sign_in
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    silence_omniauth { find(:css, "a[href=\"#{link_to_click}\"]").click }

    expect(page).
      to have_content 'Invalid credentials'
  end
end