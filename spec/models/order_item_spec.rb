require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order_item) { FactoryGirl.create :order_item }

  it "is using #update_price as a callback before validation" do
    expect(order_item).to callback(:update_price).before(:validation)
  end

  before { allow_any_instance_of(OrderItem).to receive(:update_price) }

  [:price, :quantity].each do |item|
    it "is invalid without #{item}" do
      expect(order_item).to validate_presence_of item
    end
  end

  it "is valid only when price is numerical and greater than or equal to 0" do
    expect(order_item).to validate_numericality_of(:price).
      is_greater_than 0
  end

  it "is valid only when quantity is integer and greater than or equal to 0" do
    expect(order_item).to validate_numericality_of(:quantity).only_integer.
      is_greater_than_or_equal_to 0
  end

  [:book, :order].each do |item|
    it "belongs to #{item}" do
      expect(order_item).to belong_to item
    end
  end

  context "#custom_label_method" do
    it "returns string with associated book title" do
      expect(order_item.send(:custom_label_method)).
        to eq "#{Book.find(order_item.book_id).title}"
    end
  end

  context ".order_item_from_params" do
    let(:book) { FactoryGirl.create :book }
    let(:params) { {book_id: book.id, quantity: 1} }

    subject { OrderItem.order_item_from_params(params) }

    it "receives :new with params passed" do
      expect(OrderItem).to receive(:new).with(params)
      subject
    end

    it "returns new order item" do
      expect(subject).to be_a OrderItem
      expect(subject.persisted?).to be_falsy
    end
  end

  context ".order_items_from_order_params" do
    let(:books) { FactoryGirl.create_list :book, 2 }
    let(:params) { [{book_id: books[0].id, quantity: 1},
                    {book_id: books[1].id, quantity: 2}] }
    let(:order_params) { {order_items_attrs: params} }

    subject { OrderItem.order_items_from_order_params(order_params) }

    it "receives .order_item_from_params with every params set" do
      params.each do |set|
        expect(OrderItem).to receive(:order_item_from_params).with set
      end
      subject
    end
  end

  context ".combine_order_items" do
    let(:items)        { FactoryGirl.create_list :order_item, 2 }
    let(:items_to_add) { FactoryGirl.create_list :order_item, 3 }

    subject { OrderItem.combine_order_items(items, items_to_add) }
    
    it "returns compacted collection of both sets of order_items passed" do
      expect(subject).to eq_to_items(
        OrderItem.compact_order_items(items + items_to_add))
    end
  end

  context ".compact_order_items" do
    let(:books) { FactoryGirl.create_list :book, 2 }

    subject { OrderItem.compact_order_items(@items) }

    it "doesn't affect order_items without the same book_ids" do
      @items = [FactoryGirl.create(:order_item, book_id: books[0].id),
                FactoryGirl.create(:order_item, book_id: books[1].id)]
      expect(subject).to eq_to_items @items
    end

    it "sums quantities of order_items with the same book_ids" do
      @items = FactoryGirl.create_list :order_item, 2, book_id: books[0].id
      expect(subject.size).to eq 1
      expect(subject[0].quantity).to eq(@items[0].quantity + @items[1].quantity)
    end
  end
end
