module OrderStateChanger
  private 

    def visible_for_states?
      object = bindings[:object]
      authorized? && object.is_a?(Order) && states.include?(object.state)
    end

    def change_state(sym, str)
      return proc do
        @object.public_send(sym)
        @object.completed_date = Date.today if sym == :complete
        flash[:notice] = if @object.save
          "You have #{str} order #{@object.custom_label_method}"
        else
          "Unable to #{sym} order #{@object.custom_label_method}"
        end
        redirect_to back_or_index
      end
    end
end
