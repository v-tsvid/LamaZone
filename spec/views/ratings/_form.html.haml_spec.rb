shared_examples "displaying _form partial content" do
  
  it "displays title of the book and author's name" do
    book = Book.find(subject.book_id)
    expect(rendered).to match "\"#{book.title}\" "\
      "by #{Author.find(book.author_id).firstname} "\
      "#{Author.find(book.author_id).lastname}"
  end
end