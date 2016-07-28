shared_examples 'books_categories specs' do |category_show|

  before do
    @books = assign(:books, Kaminari.paginate_array([
      FactoryGirl.create(:book),
      FactoryGirl.create(:book)]).page(1))
      @categories = assign(:categories, [
        FactoryGirl.build_stubbed(:category, title: 'bestsellers'), 
        FactoryGirl.build_stubbed(:category, title: 'other')])
  end

  [:title, :price].each do |item|
    it "displays books' #{item.to_s.pluralize}" do
      @books.each do |book|
        allow(view).to receive(:cool_price) { book.send(item) } if item == :price
        render
        expect(rendered).to match(book.send(item).to_s) 
      end
    end
  end

  before do
    allow(view).to receive(:cool_price)
    render 
  end

  it "renders _books partial" do
    expect(view).to render_template(partial: '_books', count: 1)
  end

  it "renders _book partial for every book displaying" do
    expect(view).to render_template(partial: '_book', count: 2)
  end 

  it "renders _categories partial" do
    expect(view).to render_template(partial: 'categories/_categories', count: 1)
  end

  context "_books partial content" do

    if category_show
      it "displays link to home" do
        expect(rendered).to have_link 'HOME', root_path
      end

      it "displays link to shop" do
        expect(rendered).to have_link 'SHOP', books_path
      end

      it "displays link to current category" do
        expect(rendered).to have_link(
          "#{@category.title.humanize}", category_path(@category))
      end

      it "displays current category title" do
        expect(rendered).to have_selector(
          'h4', text: "Category - #{@category.title.humanize}")
      end
    else
      it "displays caption says current category is all books" do
        expect(rendered).to have_selector 'h4', text: 'Category - All'
      end
    end
  end

  context "_book partial content" do

    it "displays linked preview of the book" do
      @books = assign(:books, Kaminari.paginate_array(
        FactoryGirl.create_list(:book, 2)).page(1))
      
      @categories = assign(:categories, [
        FactoryGirl.build_stubbed(:category, title: 'bestsellers'), 
        FactoryGirl.build_stubbed(:category, title: 'other')])

      allow_any_instance_of(Book).to receive_message_chain("images.thumb.url").
        and_return 'some_url'
      
      render
      selector = "a[href='#{book_path @books[0]}'] "\
        "img[src=\"/images/some_url\"]"
      expect(rendered).to have_selector(selector)
    end

    it "displays linked title of the book" do
      expect(rendered).to have_link "#{@books[0].title}", href: "#{book_path @books[0]}"
    end

    it "displays book price" do
      allow(view).to receive(:cool_price) { @books[0].price }
      render
      expect(rendered).to match(@books[0].price.to_s) 
    end
  end

  context "_categories partial content" do
    it "displays partial header" do
      expect(rendered). to have_selector 'h4', text: 'SHOP BY CATEGORIES'
    end

    it "displays links to categories" do
      @categories.each do |cat|
        expect(rendered).to have_link cat.title.humanize, href: category_path(cat)
      end
    end
  end
end