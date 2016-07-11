class PersonDecorator < Draper::Decorator
  def full_name
    "#{object.firstname} #{object.lastname}"
  end
end