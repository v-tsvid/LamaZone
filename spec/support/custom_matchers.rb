RSpec::Matchers.define :have_constant do |const|
  match do |owner|
    owner.const_defined?(const)
  end
end

RSpec::Matchers.define :have_helper do |method|
  match do |subject|
    subject.view_context.respond_to?(method)
  end

  failure_message do |text|
    "expected :#{method} is defined as a helper method, but it isn't"
  end

  failure_message_when_negated do |text|
    "expected :#{method} is not defined as a helper method, but it is"
  end
end

RSpec::Matchers.define :eq_to_items do |items|
  match do |subject|
    return false unless subject.length == items.length
    
    for i in 0..subject.length - 1
      [:book_id, :quantity].each do |attr|
        if subject[i].public_send(attr) != items[i].public_send(attr)
          return false
        end
      end
    end
  end

  failure_message do |text|
    "expected #{items} to be the same as #{subject} but weren't"
  end

  failure_message_when_negated do |text|
    "expected #{items} not to be the same as #{subject} but were"
  end
end