require 'rails_helper'
require 'cancan/matchers'
require 'shared/models/shared_ability_model_specs.rb'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(customer) }

  context 'authorized admin' do
    let(:customer) { FactoryGirl.create :customer }
    before { allow(customer).to receive(:is_a?).with(Admin).and_return true }

    it "can access rails_admin" do
      expect(subject).to have_abilities(:access, :rails_admin)
    end

    it "can access dashboard" do
      expect(subject).to have_abilities(:dashboard)
    end

    [:author,
     :admin, 
     :book, 
     :coupon, 
     :category, 
     :rating].each do |item|
      it "can manage #{item.to_s.pluralize}" do
        expect(subject).to have_abilities(:manage, FactoryGirl.create(item))
      end
    end

    [:read, 
     :complete_order, 
     :ship_order, 
     :cancel_order, 
     :bulk_complete_orders].each do |item|
      it "has :#{item} ability on Order" do
        expect(subject).to have_abilities(item, FactoryGirl.create(:order))
      end
    end

    it "cannot create ratings" do
      expect(subject).to not_have_abilities(:create, FactoryGirl.build(:rating))
    end
  end

  context 'authorized customer' do
    let(:customer) { FactoryGirl.create :customer }
    let(:wrong_customer) { FactoryGirl.create :customer } 

    it "can manage his own addresses only" do
      expect(subject).to have_abilities(:manage, customer.billing_address)
      expect(subject).to have_abilities(:manage, customer.shipping_address)
      expect(subject).to not_have_abilities(:manage, 
        wrong_customer.billing_address)
      expect(subject).to not_have_abilities(:manage, 
        wrong_customer.shipping_address)
    end

    it "can manage his own credit_cards only" do
      expect(subject).to have_abilities(:manage, 
        FactoryGirl.build(:credit_card, customer_id: customer.id))
      expect(subject).to not_have_abilities(:manage,
        FactoryGirl.build(:credit_card, customer_id: wrong_customer.id))
    end

    it "can read countries" do
      expect(subject).to have_abilities(:read, Country.new)
    end
    
    it "can read and update his own Customer object only" do
      expect(subject).to have_abilities([:read, :update], customer)
      expect(subject).to not_have_abilities([:read, :update], wrong_customer)
    end

    it "can create and read his own orders only" do
      expect(subject).to have_abilities([:create, :read], 
        FactoryGirl.build(:order, customer_id: customer.id))
      expect(subject).to not_have_abilities([:create, :read],
        FactoryGirl.build(:order, customer_id: wrong_customer.id))
    end

    it "can manage items in his own in_progress orders only" do
      order = FactoryGirl.create(:order, 
        customer_id: customer.id, state: 'in_progress')
      wrong_orders = [
        FactoryGirl.create(:order, 
          customer_id: wrong_customer.id, state: 'in_progress'),
        FactoryGirl.create(:order, 
          customer_id: customer.id, state: 'processing')]
      
      expect(subject).to have_abilities(:manage, 
        FactoryGirl.build(:order_item, order_id: order.id))
      wrong_orders.each do |wrong_order|
        expect(subject).to not_have_abilities(:manage,
          FactoryGirl.build(:order_item, order_id: wrong_order.id))
      end
    end

    it "can create and destroy his own ratings only" do
      expect(subject).to have_abilities([:create, :destroy], 
        FactoryGirl.build(:rating, customer_id: customer.id))
      expect(subject).to not_have_abilities([:create, :destroy],
        FactoryGirl.build(:rating, customer_id: wrong_customer.id))
    end

    it "can read ratings" do
      expect(subject).to have_abilities(:read,
        FactoryGirl.build(:rating))
    end

    it "can update and destroy his own ratings only" do
      expect(subject).to have_abilities([:update, :destroy], 
        FactoryGirl.build(:rating, customer_id: customer.id))
      expect(subject).to not_have_abilities([:update, :destroy],
        FactoryGirl.build(:rating, customer_id: wrong_customer.id))
    end

    it_behaves_like 'any customer'
  end

  context 'unauthorized customer' do
    let(:customer) { FactoryGirl.build :customer }

    it_behaves_like 'any customer'
  end
end
