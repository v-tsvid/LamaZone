require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class ShipOrder < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          authorized? && 
          bindings[:object].class == Order && 
          bindings[:object].state == Order::STATE_LIST[1]
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-arrow-right'
        end

        register_instance_option :controller do
          Proc.new do
            @object.ship
            flash[:notice] = if @object.save
              "You have turned order #{@object.custom_label_method} to shipping"
            else
              "Unable to turn order #{@object.custom_label_method} to shipping"
            end
         
            redirect_to back_or_index
          end
        end
      end
    end
  end
end