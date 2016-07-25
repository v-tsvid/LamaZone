require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'

RSpec.describe Customers::OmniauthCallbacksController do
  let(:customer) { FactoryGirl.create :customer }

  describe '#facebook' do
    subject { get :facebook }

    before do
      valid_facebook_sign_in
      request.env['devise.mapping'] = Devise.mappings[:customer]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    it 'assigns @customer' do
      subject
      expect(assigns :customer).not_to be_nil
    end

    context 'if customer was saved' do
      before do    
        allow_any_instance_of(OmniauthAuthorizer).to receive(:authorize).
          and_return customer
      end

      it 'authenticates customer' do
        subject
        expect(controller.current_customer).to eq customer
      end

      it_behaves_like 'redirecting to root_path'

      it_behaves_like('flash setting', :notice, 
        t("devise.omniauth_callbacks.success", kind: 'Facebook'))
    end

    context 'if customer was not saved' do
      before do
        allow_any_instance_of(OmniauthAuthorizer).to receive(:authorize).
          and_return nil
      end

      it "assigns session['devise.facebook_data']" do
        subject
        expect(session['devise.facebook_data']).not_to be_nil
      end

      it 'redirects to new_customer_registration_path' do
        expect(subject).to redirect_to new_customer_registration_path
      end

      it_behaves_like('flash setting', :notice, 
        t("devise.omniauth_callbacks.failure", 
          kind: 'Facebook', reason: t("facebook_authorize_failure")))
    end
  end
end