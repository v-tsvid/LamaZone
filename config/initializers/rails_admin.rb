require Rails.root.join('lib/rails_admin/approve_rating')
require Rails.root.join('lib/rails_admin/reject_rating')
require Rails.root.join('lib/rails_admin/bulk_approve_ratings')
require Rails.root.join('lib/rails_admin/bulk_reject_ratings')

require Rails.root.join('lib/rails_admin/complete_order')
require Rails.root.join('lib/rails_admin/cancel_order')
require Rails.root.join('lib/rails_admin/ship_order')
require Rails.root.join('lib/rails_admin/bulk_complete_orders')

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    
    approve_rating
    reject_rating
    bulk_approve_ratings
    bulk_reject_ratings

    ship_order
    complete_order
    cancel_order
    bulk_complete_orders


    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.excluded_models << OrderItem

  ['Author',
   'Book',
   'Category',
   'Coupon',
   'Customer', 
   'Order',
   'OrderItem', 
   'Rating'].each do |model_name|
    config.model model_name do
      unless ['Book', 'Category', 'Coupon'].include?(model_name)
        object_label_method do
          :custom_label_method
        end
      end

      exclude_fields :created_at, :updated_at

      exclude_fields(:billing_address, 
                   :shipping_address, 
                   :credit_card,
                   :next_step) if model_name == 'Order'
    end
  end
end
