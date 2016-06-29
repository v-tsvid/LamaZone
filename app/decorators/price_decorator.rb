class PriceDecorator < BaseDecorator
 
  def decorate
    @obj ? "$#{'%.2f' % @obj}" : nil
  end
end