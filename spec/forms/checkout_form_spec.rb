require 'rails_helper'

RSpec.describe CheckoutForm, type: :model do
  let(:order) { FactoryGirl.create :order_with_order_items }
  let(:checkout_form) { CheckoutForm.new(order) }
  
  subject { checkout_form }
  
  before do
    allow_any_instance_of(CheckoutForm).to receive(:update_shipping_price)
    allow_any_instance_of(CheckoutForm).to receive(:update_subtotal)
    allow_any_instance_of(CheckoutForm).to receive(:update_total_price)
  end

  [:total_price,
   :completed_date,
   :state,
   :customer,
   :next_step,
   :shipping_method,
   :shipping_price,
   :subtotal,
   :order_items,
   :billing_address,
   :shipping_address,
   :credit_card,
   :coupon].each do |item|
    it { is_expected.to respond_to item }
  end
  
  [:subtotal,
   :total_price, 
   # :customer,  
   :state, 
   :next_step].each do |item|
    it { is_expected.to validate_presence_of item }
  end

  context "when :next_step_address? returns true" do
    before do
      allow_any_instance_of(CheckoutForm).to receive(
        :next_step_address?).and_return(true)
    end

    [:subtotal, :total_price].each do |item|
      it "doesn't validate that #{item} is number greater than 0" do
        subject.public_send("#{item}=".to_sym, 0)
        expect(subject.valid?).to eq true
      end
    end
  end

  context "when :next_step_address? returns false" do
    before do
      allow_any_instance_of(CheckoutForm).to receive(
        :next_step_address?).and_return(false)
    end

    [:subtotal, :total_price].each do |item|   
      it "validates that #{item} is number greater than 0" do
        subject.public_send("#{item}=".to_sym, 0)
        expect(subject.valid?).to eq false
      end
    end
  end

  context "when :next_step_confirm_or_complete? is true" do
    before do
      allow_any_instance_of(CheckoutForm).to receive(
        :next_step_confirm_or_complete?).and_return(true)
    end

    it { is_expected.to validate_presence_of :credit_card }
  end

  context "when :next_step_confirm_or_complete? is false" do
    before do
      allow_any_instance_of(CheckoutForm).to receive(
        :next_step_confirm_or_complete?).and_return(false)
    end

    it { is_expected.not_to validate_presence_of :credit_card }
  end
  
  context "addresses validating" do
    before do
      [:billing_address, :shipping_address].each do |item|
        allow_any_instance_of(CheckoutForm).to receive(item).and_return(nil)
      end
    end

    context "when :next_step_address? is true" do
      before do
        allow_any_instance_of(CheckoutForm).to receive(
          :next_step_address?).and_return(true)
      end

      [:billing_address, :shipping_address].each do |item|
        it "validates the presence of #{item}" do
          expect(subject.valid?).to eq true
        end
      end
    end

    context "when :next_step_address? is false" do
      before do
        allow_any_instance_of(CheckoutForm).to receive(
          :next_step_address?).and_return(false)
      end

      [:billing_address, :shipping_address].each do |item|
        it "doesn't validate the presence of #{item}" do
          expect(subject.valid?).to eq false
        end
      end
    end
  end

  context "when :next_step_address_or_shipment? is true" do
    before do
      allow_any_instance_of(CheckoutForm).to receive(
        :next_step_address_or_shipment?).and_return true
    end

    it { is_expected.not_to validate_inclusion_of(:shipping_method).
      in_array(PriceCalculator::SHIPPING_METHOD_LIST) }

    it "doesn't validate that :shipping_price is number greater than or equal to 0" do
      subject.validate({shipping_price: -1})
      expect(subject.valid?).to eq true
    end
  end

  context "when :next_step_address_or_shipment? is false" do
    before do
      allow_any_instance_of(CheckoutForm).to receive(
        :next_step_address_or_shipment?).and_return false
    end

    it { is_expected.to validate_inclusion_of(:shipping_method).
      in_array(PriceCalculator::SHIPPING_METHOD_LIST) }

    # it "validates that :shipping_price is number greater than or equal to 0" do
    #   subject.validate({shipping_price: -1})
    #   expect(subject.valid?).to eq false
    # end
  end

  it { is_expected.to validate_presence_of :order_items }
  it { is_expected.to validate_inclusion_of(:state).in_array(Order::STATE_LIST) }

  it "validates that completed_date is a correct date" do
    subject.completed_date = "incorrect date"
    expect(subject.valid?).to eq false
  end

  context "#persisted?" do
    subject { checkout_form.persisted? }
    it { is_expected.to eq false }
  end

  context "#valid?" do
    [:update_shipping_price, 
     :update_subtotal, 
     :update_total_price].each do |item|
      it "receives #{item}" do
        expect(subject).to receive(item)
        subject.valid?
      end
    end
  end

  [['confirm', 'complete'], ['address', 'shipment']].each do |item|

    context "#next_step_#{item[0]}_or_#{item[1]}?" do
      subject { checkout_form.send("next_step_#{item[0]}_or_#{item[1]}?".to_sym) }

      item.each do |sub_item|
        context "when next_step is \'#{sub_item}\'" do
          before do
            allow(checkout_form).to receive(:next_step).and_return sub_item
          end

          it { is_expected.to eq true }
        end
      end

      context "when next_step is neither '#{item[0]}' nor '#{item[1]}'" do
        before do
          allow(checkout_form).to receive(:next_step).and_return 'payment'
        end

        it { is_expected.to eq false }
      end
    end
  end

  ['address', 'shipment'].each do |item|
    context "#next_step_#{item}?" do
      subject { checkout_form.send("next_step_#{item}?".to_sym) }

      context "when next_step is '#{item}'" do
        before do
          allow(checkout_form).to receive(:next_step).and_return item
        end

        it { is_expected.to eq true }
      end


      context "when next_step is not '#{item}'" do
        before do
          allow(checkout_form).to receive(:next_step).and_return 'payment'
        end

        it { is_expected.to eq false }
      end
    end
  end
end