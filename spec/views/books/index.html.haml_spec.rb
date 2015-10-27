require 'rails_helper'

RSpec.describe "books/index", type: :view do

  before { @books = FactoryGirl.create_list :book, 2 }
  
  it "renders _books partial" do
    render
    expect(view).to render_template(partial: '_book', count: 2)
  end

  [:title, :price].each do |item|
    it "displays books' #{item.to_s.pluralize}" do
      render
      [0, 1].each do |num|
        expect(rendered).to match(@books[num].send(item).to_s) 
      end
    end
  end

  [:firstname, :lastname].each do |item|
    it "displays #{item} of books' authors" do
      render
      [0, 1].each do |num|
        expect(rendered).to match(@books[num].author.send(item).to_s) 
      end
    end
  end
end
