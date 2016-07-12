class BookDecorator < Draper::Decorator
  def title_author
    "#{object.title} #{I18n.t(:by_author)} "\
    "object.author.decorate.full_name"
  end
end