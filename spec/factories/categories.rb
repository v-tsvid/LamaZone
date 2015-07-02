FactoryGirl.define do
  factory :category do
    title { Faker::Lorem.words(rand(1..3)).join(' ') }

    factory :category_with_books do
      transient do
        books_count 5
      end
      after(:create) do |category, evaluator|
        create_list(:book, evaluator.books_count, category: category)
      end
    end
  end

end
