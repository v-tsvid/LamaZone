require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class BulkApproveRatings < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          authorized? && bindings[:abstract_model].model == Rating
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :controller do
          Proc.new do
            @objects = list_entries(@model_config)
            @objects.each do |object|
              object.update_attribute(:state, 'approved')
            end
            flash[:success] = "Ratings were successfully approved."
            redirect_to back_or_index
          end
        end
      end
    end
  end
end