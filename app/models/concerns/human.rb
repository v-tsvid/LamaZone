module Human
  extend ActiveSupport::Concern

  def full_name
    "#{self.firstname} #{self.lastname}"
  end
end