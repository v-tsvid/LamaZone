module PersonMethods
  extend ActiveSupport::Concern

  def custom_label_method
    self.decorate.full_name
  end
end