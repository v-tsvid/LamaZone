require 'rails_helper'

RSpec.describe OmniauthAuthorizer do

  before do
    valid_facebook_sign_in
    @auth = OmniAuth.config.mock_auth[:facebook]
  end

  describe "#initialize" do
    subject { OmniauthAuthorizer.new(@auth) }

    it "assigns auth passed as @auth" do
      subject
      expect(subject.instance_variable_get(:@auth)).to eq @auth
    end
  end

  describe "#authorize" do
    subject { OmniauthAuthorizer.new(@auth).authorize }

    context 'if valid credentials received' do
    
      it "returns customer" do
        expect(subject).to be_a Customer
      end

      it "sets customer firstname" do
        expect(subject.firstname).to eq @auth.info.first_name
      end

      it "sets customer lastname" do
        expect(subject.lastname).to eq @auth.info.last_name
      end

      context 'email setting' do
        before do
          allow(@auth).to receive_message_chain("info.first_name")
          allow(@auth).to receive_message_chain("info.last_name")
        end

        it "sets customer email to info.email if it exists" do
          allow(@auth).to receive_message_chain("info.email").and_return 'email'
          expect(subject.email).to eq 'email'
        end

        it "generates customer email if info.email is nil" do
          allow(@auth).to receive_message_chain("info.email").and_return nil
          allow_any_instance_of(Customer).to receive(:email_for_facebook).
            and_return 'generated_email'
          expect(subject.email).to eq 'generated_email'
        end
      end

      it "sets customer password" do
        expect(subject.firstname).to eq @auth.info.first_name
      end
    end

    context 'if invalid credentials received' do
      before do
        allow(@auth).to receive(:info).and_return nil
      end

      it "returns nil" do
        expect(subject).to eq nil
      end
    end
  end
end