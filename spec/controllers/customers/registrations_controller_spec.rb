require 'rails_helper'
require 'shared/shared_specs'

RSpec.describe Customers::RegistrationsController, type: :controller do

  describe "DELETE #destroy" do
    let(:customer) { FactoryGirl.create :customer }

    before do
      request.env["devise.mapping"] = Devise.mappings[:customer]
      sign_in customer
      request.env["HTTP_REFERER"] = edit_customer_registration_path(customer)
    end

    subject { delete :destroy, {id: customer.id} }

    context "if params[:confirm] != 1" do
      before { allow(controller).to receive(:params).and_return({confirm: 0}) }

      it_behaves_like 'redirecting to :back'
      it_behaves_like 'flash setting', :notice, t("controllers.confirm_risks")
    end
  end
end