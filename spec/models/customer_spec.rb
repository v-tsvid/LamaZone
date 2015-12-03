require 'rails_helper'
require 'support/utilities'

RSpec.describe Customer, type: :model do
  let(:customer) { FactoryGirl.create :customer }

  [:password, :password_confirmation].each do |item|
    it "responds to #{item}" do
      expect(customer).to respond_to(item)
    end
  end

  [:email, 
   :firstname, 
   :lastname].each do |item|
    it "is invalid without #{item}" do
      expect(customer).to validate_presence_of item
    end
  end

  it "does not allow case insensitive duplicating email" do
    expect(customer).to validate_uniqueness_of(:email).case_insensitive
  end

  it "does not allow password contains less than 8 chars" do
    expect(customer).to validate_length_of(:password).is_at_least 8
  end

  it "requires password confirmation" do
    expect(customer).to validate_confirmation_of(:password)
  end

  it "is invalid when password does not match confirmation" do
    customer.password_confirmation = "mismatch"
    expect(customer).not_to be_valid
  end

  [:orders, :ratings, :addresses].each do |item|
    it "has many #{item}" do
      expect(customer).to have_many item
    end
  end

  it "is using #downcase_email as a callback before save" do
    expect(customer).to callback(:downcase_email).before(:save)
  end
  
  context ".from_omniauth" do

    before do
      valid_facebook_sign_in
      @auth = OmniAuth.config.mock_auth[:facebook]
    end

    it "returns first customer with required 'uid' and 'provider' of finded" do
      customers = FactoryGirl.create_list :customer, 2, uid: @auth.uid
      expect(Customer.from_omniauth(@auth)).to eq customers[0]
    end

    it "returns new customer if didn't find required" do
      expect{ Customer.from_omniauth(@auth) }.to change { Customer.count }.by 1
    end    

    [:uid, :provider].each do |item|
      it "new customer has required '#{item.to_s}'" do
        expect(Customer.from_omniauth(@auth).send(item)).to eq @auth.send(item) 
      end
    end

    {email: :email, 
     firstname: :first_name, 
     lastname: :last_name}.each do |key, value|
      
      it "if creates customer, sets it's '#{key}' equal to one in auth hash" do
        expect(Customer.from_omniauth(@auth).send(key)).
          to eq @auth.info.send(value)
      end
    end

    it "if creates customer, sets it's password to 20-chars string" do
      expect(Customer.from_omniauth(@auth).password.length).to eq 20
    end

    it "if creates customer, sets password_confirmation equal to password" do
      customer = Customer.from_omniauth(@auth)
      expect(customer.password_confirmation).
        to eq customer.password
    end
  end

  context "#custom_label_method" do
    it "returns string with lastname and firstname" do
      expect(customer.send(:custom_label_method)).
        to eq "#{customer.lastname} #{customer.firstname}"
    end
  end

  context "#downcase_email" do
    it "turns email in downcase" do
      expect(customer.email).to receive(:downcase!).
        and_return(customer.email.downcase!)
      customer.send(:downcase_email)
    end
  end

  context "#add_order" do
    it "adds new order" do
      expect(customer.send(:add_order).new_record?).to be true
    end
  end

  context "#order_in_progress" do
    it "returns first order in progress" do
      orders = FactoryGirl.create_list(:order, 3, customer_id: customer.id, 
        state: 'in_progress')
      expect(customer.send(:order_in_progress)).to eq orders.first
    end
  end

  context "#full_name" do
    it "returns string wih lastname joined to firstname" do
      expect(customer.send(:full_name)).
        to eq "#{customer.firstname} #{customer.lastname}"
    end
  end
end
