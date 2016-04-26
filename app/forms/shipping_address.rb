class ShippingAddress < Reform::Form
  extend ::ActiveModel::Callbacks
  include AddressModule
end