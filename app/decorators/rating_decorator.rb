class RatingDecorator < Draper::Decorator

  def author_and_date
    " #{I18n.t :by} #{PersonDecorator.decorate(object.customer).full_name}, "\
    "#{DateDecorator.decorate(object.updated_at).date}"
  end
end