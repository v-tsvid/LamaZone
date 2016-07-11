class DateDecorator < Draper::Decorator
 
  def date
    object ? "#{I18n.l(object)}" : nil
  end
end