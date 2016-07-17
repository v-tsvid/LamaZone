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