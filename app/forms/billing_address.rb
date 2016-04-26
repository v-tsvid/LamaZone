class BillingAddress < Reform::Form
  extend ::ActiveModel::Callbacks
  include AddressModule
end