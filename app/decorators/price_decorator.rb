class PriceDecorator < BaseDecorator
 
  def decorate
    "$#{'%.2f' % @obj}"
  end
end