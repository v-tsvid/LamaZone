module RatingStateChanger
  private 

    def visible_for_state_not?(str)
      authorized? && 
      bindings[:object].class == Rating && 
      bindings[:object].state != str
    end

    def change_state(str)
      return proc do
        @object.update_attribute(:state, str)
        flash[:notice] = "You have #{str} the "\
                         "#{@object.custom_label_method}"
     
        redirect_to back_or_index
      end
    end
end
