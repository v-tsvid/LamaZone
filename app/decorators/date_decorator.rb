class DateDecorator < BaseDecorator
 
  def decorate
    "#{@obj.strftime("%B %d, %Y")}"
  end
end