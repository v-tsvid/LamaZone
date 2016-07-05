class OrderDecorator < BaseDecorator
 
  def decorate
    "R%09d" % @obj.id
  end
end