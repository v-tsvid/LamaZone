require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class RejectRating < RailsAdmin::Config::Actions::Base
        include RatingStateChanger

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          visible_for_state_not? 'rejected'
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-remove-sign'
        end

        register_instance_option :controller do
          change_state 'rejected'
        end
      end
    end
  end
end