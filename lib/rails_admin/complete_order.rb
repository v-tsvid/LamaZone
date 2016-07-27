require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require 'rails_admin/order_state_changer'
 
module RailsAdmin
  module Config
    module Actions
      class CompleteOrder < RailsAdmin::Config::Actions::Base
        include OrderStateChanger

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          visible_for_states?
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :controller do
          change_state :complete, 'completed'
        end

        private 

          def states
            Order::STATE_LIST[1, 2]
          end
      end
    end
  end
end