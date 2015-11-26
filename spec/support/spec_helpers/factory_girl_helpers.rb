module FactoryGirlHelpers
  def array_of(obj)
    ary = []
    if obj.count > 0
      Random.rand(0..3).times do
        item = obj.all.sample
        ary.push(item) unless ary.include?(item) 
      end
    end
    ary 
  end
end