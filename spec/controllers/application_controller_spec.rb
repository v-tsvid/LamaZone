require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller {}

  let(:customer) { FactoryGirl.build_stubbed(:customer) }

  it "has a PATHS constant" do
    expect(ApplicationController::PATHS).not_to eq nil
  end

  [:configure_permitted_parameters, :set_locale].each do |filter|
    it { is_expected.to use_before_action(filter) }
  end

  it { is_expected.to use_after_filter(:store_location) }
  
  it { is_expected.to alias_from(:current_user).to(:current_customer) }
  
  it { is_expected.to rescue_from(
    ActionController::RoutingError).with(:handle_routing_error) }
  it { is_expected.to rescue_from(
    CanCan::AccessDenied).with(:handle_access_denied) }

  [:current_order, :order_from_cookies].each do |method|
    it "defines :#{method} as a helper_method" do
      expect(controller).to have_helper(method)
    end
  end

  describe "#routing_error" do
    it "raises ActionController::RoutingError with params[:path]" do
      allow(controller).to receive(:params).and_return({path: '/'})
      expect(lambda{ controller.routing_error }).to raise_error(
          ActionController::RoutingError, '/')
    end
  end

  describe "#set_locale" do
    shared_examples 'setting omniauth locale' do
      it "sets session[:omniauth_login_locale] equal to I18n.locale" do
        expect(controller.session[:omniauth_login_locale]).to eq I18n.locale
      end
    end

    subject { controller.set_locale }

    context "when params[:locale] is not nil" do
      before do
        allow(controller).to receive(:params).and_return({locale: :de})
        subject
      end

      it "sets I18n.locale equal to params[:locale]" do
        expect(I18n.locale).to eq controller.params[:locale]
      end

      it_behaves_like 'setting omniauth locale'
    end

    context "when params[:locale] is nil "\
            "but session[:omniauth_login_locale] is not" do

      before do
        allow(controller).to receive(:session).and_return(
          {omniauth_login_locale: :de})
        subject
      end
      
      it "sets I18n.locale equal to session[:omniauth_login_locale]" do
        expect(I18n.locale).to eq controller.session[:omniauth_login_locale]
      end

      it_behaves_like 'setting omniauth locale'
    end

    context "when both params[:locale] "\
            "and session[:omniauth_login_locale] are nil" do

      before do
        allow(I18n).to receive(:default_locale).and_return :de
        subject
      end
      
      it "sets I18n.locale equal to I18n.default_locale" do
        expect(I18n.locale).to eq I18n.default_locale
      end

      it_behaves_like 'setting omniauth locale'
    end
  end

  describe "#default_url_options" do
    it "returns {locale: I18n.locale} hash merged with hash passed in" do
      expect(controller.default_url_options({key: 'value'})).to eq(
        {locale: I18n.locale, key: 'value'})
    end
  end

  describe "#store_location" do
    context "when last_url_to_store? is true" do
      before do
        allow(controller).to receive(:last_url_to_store?).and_return true
        allow(controller).to receive_message_chain("request.fullpath").
          and_return('/')
      end

      it "sets previous url to current requested url" do
        expect{ controller.send(:store_location) }.
          to change {controller.session[:previous_url] }.to '/'
      end
    end
  end

  describe "#last_url_to_store?" do
    subject { controller.send(:last_url_to_store?) }

    before do
      allow(controller).
        to receive_message_chain("request.get?").and_return true
      allow(controller).
        to receive_message_chain("request.xhr?").and_return false
    end

    context "if non-xml get request received and path is not in list" do
      before do
        allow(controller).
          to receive_message_chain("request.path").and_return '/'
      end

      it { is_expected.to eq true }
    end

    context "otherwise" do
      before do
        allow(controller).to receive_message_chain("request.path").and_return(
          ApplicationController::PATHS.sample)
      end

      it { is_expected.to eq false }
    end
  end

  describe "#after_sign_in_path_for" do
    subject {controller.send(:after_sign_in_path_for, customer) }

    context "when previous url was cart_path" do
      before do
        allow(controller).to receive(:session).and_return(
          {previous_url: cart_path})
      end

      it "returns cart_path" do
        expect(subject).to eq cart_path
      end
    end
  end

  describe "#after_sign_out_path_for" do
    subject {controller.send(:after_sign_out_path_for, customer) }

    it "returns root_path" do
      expect(subject).to eq root_path
    end
  end
end