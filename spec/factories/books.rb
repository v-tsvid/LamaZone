CARRIERWAVE_IMAGES = ["app/assets/images/books-images/41OgOIZBVPL.jpg",
                      "app/assets/images/books-images/4133VHHWJ1L.jpg",
                      "app/assets/images/books-images/51-W1m2z4WL.jpg",
                      "app/assets/images/books-images/51AdUxb4frL.jpg",
                      "app/assets/images/books-images/51KBQZS9L.jpg",
                      "app/assets/images/books-images/51N9CNkljL.jpg",
                      "app/assets/images/books-images/51TX2yVUq0L.jpg",
                      "app/assets/images/books-images/51TxDaEbL._SX331_BO1,204,203,200_.jpg",
                      "app/assets/images/books-images/61KPB4YQnRL.jpg",
                      "app/assets/images/books-images/71-qtQ6xR1L.jpg"]

FactoryGirl.define do
  factory :book do
    title { Faker::Lorem.words(rand(1..7)).join(' ') }
    description { Faker::Lorem.paragraphs(rand(3..5)).join('\n') }
    price { rand(10.0..100.0).round(2) }
    books_in_stock { rand(1..100) }
    images File.open(File.join(Rails.root, CARRIERWAVE_IMAGES.sample))
    author

    factory :book_with_ratings do
      transient do
        ratings_count { rand(1..10) }
      end
      after(:create) do |book, evaluator|
        create_list(:rating, evaluator.ratings_count, book: book)
      end
    end

    factory :book_with_categories do
      transient do
        ary { array_of(Book) }
      end
      after(:create) do |book, ev|
        create_list(:category, rand(1..3), books: ev.ary.push(book).uniq)
      end
    end
    
    factory :book_of_category do
      after(:create) do |book, ev|
        create(:category, books: [book])
      end
    end

    factory :bestseller_book do
      after(:create) do |book, ev|
        create(:category, books: [book], title: "bestsellers")
      end
    end
  end
end
