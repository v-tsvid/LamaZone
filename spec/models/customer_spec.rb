require 'rails_helper'
require 'support/utilities'

RSpec.describe Customer, type: :model do
  let(:customer) { FactoryGirl.create :customer }

  [:password, :password_confirmation].each do |item|
    it "responds to #{item}" do
      expect(customer).to respond_to(item)
    end
  end

  it "is invalid without email" do
      expect(customer).to validate_presence_of :email
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

  [:orders, :ratings].each do |item|
    it "has many #{item}" do
      expect(customer).to have_many item
    end
  end

  [:billing_address, :shipping_address].each do |item|
    it "has one #{item}" do
      expect(customer).to have_one item
    end
  end

  it "is using #downcase_email as a callback before save" do
    expect(customer).to callback(:downcase_email).before(:save)
  end

  context "#current_order_of_customer" do
    let(:order) { FactoryGirl.create :order }
    subject { customer.current_order_of_customer }

    it "returns order in progress of the customer if found" do
      allow(Order).to receive(:find_by).and_return order
      expect(subject).to eq order
    end

    it "returns nil if order not found" do
      allow(Order).to receive(:find_by).and_return nil
      expect(subject).to eq nil
    end
  end

  context "#email_for_facebook" do
    subject { customer.email_for_facebook }
    
    it "returns generated fake email" do
      expect(subject).to eq(
        "#{customer.lastname}_#{customer.firstname}"\
        "#{Customer.last.id + 1}@facebook.com")
    end
  end

  context ".by_facebook" do
    let(:auth) { OmniAuth::AuthHash.new({provider: 'facebook', uid: '12345'}) }
    subject { Customer.by_facebook(auth) }
    
    it "returns customer found by auth provider and uid" do
      allow(Customer).to receive(:where).with(
        provider: auth.provider, uid: auth.uid).and_return customer
      expect(subject).to eq customer
    end
  end

  context "#custom_label_method" do
    it "returns string with lastname and firstname" do
      expect(customer.send(:custom_label_method)).
        to eq customer.decorate.full_name
    end
  end

  context "#downcase_email" do
    it "turns email in downcase" do
      expect(customer.email).to receive(:downcase!).
        and_return(customer.email.downcase!)
      customer.send(:downcase_email)
    end
  end
end
