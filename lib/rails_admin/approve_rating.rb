require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class ApproveRating < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          authorized? && 
          bindings[:object].class == Rating && 
          bindings[:object].state != 'approved'
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :controller do
          Proc.new do
            @object.update_attribute(:state, 'approved')
            flash[:notice] = "You have approved the "\
                             "#{@object.custom_label_method}"
         
            redirect_to back_or_index
          end
        end
      end
    end
  end
end