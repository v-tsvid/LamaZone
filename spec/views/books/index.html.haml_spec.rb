require 'rails_helper'

RSpec.describe "books/index", type: :view do

  before do
    @books = FactoryGirl.create_list :book, 2
    @categories = FactoryGirl.create_list :category, 2
    render
  end

  it "renders _book partial" do
    expect(view).to render_template(partial: '_book', count: 2)
  end    
  
  it "displays categories' titles" do
    @categories.each do |cat|
      expect(rendered).to match(cat.title)
    end
  end

  [:title, :price].each do |item|
    it "displays books' #{item.to_s.pluralize}" do
      @books.each do |book|
        expect(rendered).to match(book.send(item).to_s) 
      end
    end
  end

  [:firstname, :lastname].each do |item|
    it "displays #{item} of books' authors" do
      @books.each do |book|
        expect(rendered).to match(book.author.send(item).to_s) 
      end
    end
  end
end
