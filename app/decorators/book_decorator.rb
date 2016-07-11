class BookDecorator < Draper::Decorator
  def title_author
    "#{object.title} #{I18n.t(:by_author)} "\
    "#{PersonDecorator.decorate(object.author).full_name}"
  end
end