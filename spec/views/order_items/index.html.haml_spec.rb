require 'rails_helper'

RSpec.describe "order_items/index", type: :view do
  before(:each) do
    @first_book = stub_model(Book, title: 'great_title', price: 1)
    @second_book = stub_model(Book, title: 'nice_title', price: 2)
    
    @order_items = assign(:order_items, [
      stub_model(OrderItem, book: @first_book, price: 2, quantity: 2,), 
      stub_model(OrderItem, book: @second_book, price: 8, quantity: 4)])

    @order = assign(:order, stub_model(Order))

    allow_any_instance_of(Order).to receive(:order_items).and_return @order_items
    allow(view).to receive(:cool_price)
    allow(view).to receive(:current_order)

    render
  end

  it "renders _order_item partial for each order_item" do
    expect(view).to render_template(partial: '_order_item', count: 2)
  end

  it "displays order-items' quantities" do
    @order_items.each do |item|
      expect(rendered).to have_selector "input[type='number'][value='#{item.send(:quantity)}']"
    end
  end   

  [:title, :price].each do |param|
    it "displays order_items' books' #{param.to_s.pluralize}" do
      [@first_book, @second_book].each do |book|
        allow(view).to receive(:cool_price).and_return(book.price) if param == :price
        render
        expect(rendered).to have_content book.send(param)
      end
    end
  end

  it "displays delete buttons for each order_item" do
    @order_items.each do |item|
      expect(rendered).to have_link 'X', item
    end
  end

  it "displays 'back to shopping' link" do
    expect(rendered).to have_link 'CONTINUE SHOPPING', books_path
  end
end
