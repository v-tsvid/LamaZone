require 'rails_helper'
require 'shared/forms/shared_address_module_specs'

RSpec.describe BillingAddressForm, type: :model do
  it_behaves_like 'address form specs'
end