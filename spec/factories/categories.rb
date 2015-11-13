FactoryGirl.define do
  sequence(:title) { |n| "Category #{n}" }
  factory :category do
    title

    factory :category_with_books do
      # transient do
      #   books_count 5
      # end
      after(:create) do |category|
        create_list(:book, rand(3..10), categories: [category])
      end
    end

    factory :category_with_books_with_ratings do
      transient do
        ary { array_of_categories }
      end
      after(:create) do |cat, ev|
        create_list(:book_with_ratings, rand(3..10), categories: ev.ary.push(cat))
      end
    end
  end

end
