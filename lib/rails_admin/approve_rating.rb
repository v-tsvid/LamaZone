require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require 'rails_admin/rating_state_changer'
 
module RailsAdmin
  module Config
    module Actions
      class ApproveRating < RailsAdmin::Config::Actions::Base
        include RatingStateChanger

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          visible_for_state_not? 'approved'
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :controller do
          change_state 'approved'
        end
      end
    end
  end
end