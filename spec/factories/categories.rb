FactoryGirl.define do
  sequence(:title) { |n| "category#{n}" }
  factory :category do
    title

    factory :category_with_books do
      transient do
        ary { array_of(Category) }
        num { rand(3..10) }
      end
      after(:create) do |cat, ev|
        create_list(:book, ev.num, 
          categories: ev.ary.push(cat).uniq)
      end
    end

    factory :category_with_books_with_ratings do
      transient do
        ary { array_of(Category) }
      end
      after(:create) do |cat, ev|
        create_list(:book_with_ratings, rand(3..10), 
          categories: ev.ary.push(cat).uniq)
      end
    end
  end

end
