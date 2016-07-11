class CreditCardDecorator < Draper::Decorator
 
  def number
    "**** **** **** #{object.number.split("").last(4).join("")}"
  end
end