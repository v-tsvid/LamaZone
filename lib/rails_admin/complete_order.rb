require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class CompleteOrder < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          authorized? && 
          bindings[:object].class == Order && 
          bindings[:object].state != Order::STATE_LIST[0] &&
          bindings[:object].state != Order::STATE_LIST[3] &&
          bindings[:object].state != Order::STATE_LIST[4]
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :controller do
          Proc.new do
            @object.complete
            @object.completed_date = Date.today
            flash[:notice] = if @object.save
              "You have completed order #{@object.custom_label_method}"
            else
              "Unable to complete order #{@object.custom_label_method}"
            end
         
            redirect_to back_or_index
          end
        end
      end
    end
  end
end