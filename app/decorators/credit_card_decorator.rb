module CreditCardDecorator 
  def self.extended(mod)
    mod.class.send(:alias_method, :plain_number, :number)
  end
 
  def number
    "**** **** **** #{plain_number.split("").last(4).join("")}"
  end
end