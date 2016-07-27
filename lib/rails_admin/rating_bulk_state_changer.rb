module RatingBulkStateChanger
  private 

    def visible_for_ratings?
      authorized? && bindings[:abstract_model].model == Rating
    end

    def bulk_change_state(str)
      return proc do
        @objects = list_entries(@model_config)
        @objects.each do |object|
          object.update_attribute(:state, str)
        end
        flash[:success] = "Ratings were successfully #{str}."
        redirect_to back_or_index
      end
    end
end
