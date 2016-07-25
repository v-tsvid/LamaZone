require 'features/features_spec_helper'
require 'shared/features/shared_shopping_feature_specs'
  
feature 'shopping' do
  let(:books) { FactoryGirl.create_list :book, 2 }

  context "when unauthorized customer" do
    background do
      visit book_path(books[0])
      click_button t(:add_to_cart)
    end

    it_behaves_like "any customer"

    scenario "redirected to authentication after clicking checkout" do
      visit cart_path
      click_button t("checkout.checkout")

      expect(page).to have_content t("devise.failure.unauthenticated")
    end
  end

  context "when authorized customer" do
    let(:customer) { FactoryGirl.create :customer }

    background do
      page.driver.delete destroy_admin_session_path
      page.driver.delete destroy_customer_session_path

      login_as customer
      visit book_path(books[0])
      click_button t(:add_to_cart)
    end

    it_behaves_like "any customer"

    context "performing checkout" do
      let(:coupon) { FactoryGirl.create :coupon, code: '12345' }

      background { visit cart_path }

      scenario "simple checkout" do
        click_button t("checkout.checkout")
        expect(page).to have_css "u.nav.nav-tabs"
      end

      scenario "checkout with coupon" do
        fill_in 'order_coupon_code', with: coupon.code
        click_button t("checkout.checkout")

        expect(page).to have_css "u.nav.nav-tabs"
        expect(page).to have_content "#{coupon.discount}%"
      end
    end

    context "checkout progress" do
      background do 
        visit cart_path
        click_button t("checkout.checkout")
      end
      
      context "addresses entering" do
        include_context 'address tab'

        scenario "enter addresses" do
          expect(page).to have_content t("shipping_method")
        end
      end

      context "shipping method selection" do
        include_context 'address tab'
        include_context 'shipping method tab'

        scenario "choose the shipping method" do
          expect(page).to have_content t("c_card")
          expect(page).to have_content PriceDecorator.decorate(15).price
        end
      end

      context "payment info entering" do
        include_context 'address tab'
        include_context 'shipping method tab'
        include_context 'payment tab'

        scenario "enter the payment info" do
          expect(page).to have_selector(
            :link_or_button, t("checkout.place_order"))
        end
      end

      context "order placing" do
        include_context 'address tab'
        include_context 'shipping method tab'
        include_context 'payment tab'

        scenario "place the order" do
          click_button t("checkout.place_order")
          expect(page).to have_selector(
            :link_or_button, t("checkout.back_to_store"))
        end
      end
    end

    scenario "see the list of the own orders" do
      orders = FactoryGirl.create_list(
        :order, 2, customer_id: customer.id, state: 'completed')
      visit orders_path

      orders.each do |order|
        expect(page).to have_content order.decorate.number
      end
    end

    scenario "see the details of the own order" do
      order = FactoryGirl.create(
        :order, customer_id: customer.id, state: 'completed')
      visit order_path(order)
      expect(page).to have_content order.decorate.number
    end
  end
end