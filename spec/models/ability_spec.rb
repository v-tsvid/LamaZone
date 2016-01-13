require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(customer) }

  shared_examples 'any customer' do
    ['Author', 'Book', 'Category', 'Rating'].each do |item|
      it "can read any #{item.downcase}" do
        expect(subject).to have_abilities(:read, item.constantize)
      end
    end
  end

  context 'authorized customer' do
    let(:customer) { FactoryGirl.create :customer }
    let(:wrong_customer) { FactoryGirl.create :customer } 

    [:address, :credit_card].each do |item|
      it "can manage his own #{item} only" do
        expect(subject).to have_abilities(:manage, 
          FactoryGirl.build(item, customer_id: customer.id))
        expect(subject).to not_have_abilities(:manage,
          FactoryGirl.build(item, customer_id: wrong_customer.id))
      end
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

    it "can manage items in his own orders only" do
      order = FactoryGirl.create :order, customer_id: customer.id
      wrong_order = FactoryGirl.create :order, customer_id: wrong_customer.id
      
      expect(subject).to have_abilities(:manage, 
        FactoryGirl.build(:order_item, order_id: order.id))
      expect(subject).to not_have_abilities(:manage,
        FactoryGirl.build(:order_item, order_id: wrong_order.id))
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
