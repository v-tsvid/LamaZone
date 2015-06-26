json.array!(@books) do |book|
  json.extract! book, :id, :title, :description, :price, :books_in_stock
  json.url book_url(book, format: :json)
end
