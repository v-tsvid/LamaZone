class RatingDecorator < BaseDecorator

  def author_and_date
    " #{I18n.t :by} #{@obj.customer.full_name}, "\
    "#{DateDecorator.new(@obj.updated_at).decorate}"
  end
end