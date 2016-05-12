require 'rails_helper'
require 'forms/address_module_shared_examples'

RSpec.describe BillingAddressForm, type: :model do
  it_behaves_like 'address form specs'
end