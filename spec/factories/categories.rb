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
  end

end
