shared_examples 'book removing' do |flash|
  scenario "remove book from cart" do
    visit cart_path
    first(:link, t("checkout.remove")).click

    expect(page).to have_content flash
  end
end

shared_examples "any customer" do

  scenario "add book to cart" do
    expect(page).to have_content t("controllers.added")
  end

  context "NOT the last book removing" do
    background do
      visit book_path(books[1])
      click_button t(:add_to_cart)
      visit cart_path
    end

    it_behaves_like 'book removing', t("controllers.removed")
  end

  context "last book removing" do
    it_behaves_like 'book removing', t("controllers.cart_is_empty")
  end

  scenario 'browse books in the cart' do
    visit book_path(books[1])
    click_button t(:add_to_cart)
    visit cart_path

    expect(page).to have_content "#{books[0].title}"
    expect(page).to have_content "#{books[1].title}"
  end 

  scenario "update cart content" do
    visit cart_path
    click_button t("checkout.update_cart")

    expect(page).to have_content t("controllers.updated")
  end

  scenario "empty cart" do
    visit cart_path
    click_link t("checkout.empty_cart")

    expect(page).to have_content t("controllers.cart_is_empty")
  end
end

shared_context 'address tab' do
  before do
    ['billing', 'shipping'].each do |addr|
      {firstname: 'Firstname',
       lastname: 'Lastname',
       phone: '380930000000',
       address1: 'address',
       city: 'City',
       zipcode: '12345'}.each do |key, val|
        fill_in "order_model_#{addr}_address_#{key}", with: val
      end
    end
    click_button t("checkout.save_and_continue")
  end
end

shared_context 'shipping method tab' do
  before do
    choose 'order_model_shipping_method_ups_one_day'
    click_button t("checkout.save_and_continue")
  end
end

shared_context 'payment tab' do
  before do
    {firstname: 'Firstname',
     lastname: 'Lastname',
     number: '5457092903108219',
     cvv: '123'}.each do |key, val|
      fill_in "order_model_credit_card_#{key}", with: val
    end

    find('#order_model_credit_card_expiration_month').
      find(:xpath, 'option[11]').select_option
    find('#order_model_credit_card_expiration_year').
      find(:xpath, 'option[3]').select_option

    click_button t("checkout.save_and_continue")
  end
end