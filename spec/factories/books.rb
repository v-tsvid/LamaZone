FactoryGirl.define do
  factory :book do
    title { Faker::Lorem.words(rand(1..7)).join(' ') }
    description { Faker::Lorem.paragraphs(rand(3..5)).join('\n') }
    price { rand(10.0..100.0) }
    books_in_stock { rand(1..100) }
    author
    category

    factory :book_with_ratings do
      transient do
        ratings_count 5
      end
      after(:create) do |book, evaluator|
        create_list(:rating, evaluator.ratings_count, book: book)
      end
    end
  end
end
