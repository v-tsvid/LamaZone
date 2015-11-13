module FactoryGirlHelpers
  def array_of_categories
    ary = []
    if Category.count > 0
      Random.rand(0..3).times do
        item = Category.all.sample
        ary.push(item) unless ary.include?(item) 
      end
    end
    ary 
  end
end