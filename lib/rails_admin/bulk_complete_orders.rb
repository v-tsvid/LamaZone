require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class BulkCompleteOrders < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          authorized? && bindings[:abstract_model].model == Order
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :controller do
          Proc.new do
            @objects = list_entries(@model_config)
            if @objects.any? { |object| object.may_complete? == false }
              flash[:alert] = "One or few Orders are "\
                                "unable to complete"
            else
              @objects.each do |object|
                object.complete
                object.completed_date = Date.today
                object.save  
              end
              flash[:success] = "Orders were successfully completed."
            end
            redirect_to back_or_index
          end
        end
      end
    end
  end
end