class DateDecorator < BaseDecorator
 
  def decorate
    @obj ? "#{I18n.l(@obj)}" : nil
  end
end