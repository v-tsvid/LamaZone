require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require 'rails_admin/rating_bulk_state_changer'
 
module RailsAdmin
  module Config
    module Actions
      class BulkApproveRatings < RailsAdmin::Config::Actions::Base
        include RatingBulkStateChanger

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          visible_for_ratings?
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :controller do
          bulk_change_state('approved')
        end
      end
    end
  end
end