require 'rails_helper'
require 'shared/models/shared_models_specs'

RSpec.describe Rating, type: :model do
  let(:rating) { FactoryGirl.create :rating }

  it "is invalid without state" do
    expect(rating).to validate_presence_of(:state)
  end

  it "is valid only when rate is integer from 1 to 10 or nil" do
    expect(rating).to validate_numericality_of(:rate).only_integer.
      is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10).allow_nil
  end

  it "is valid only when state has permitted value" do
    expect(rating).to validate_inclusion_of(:state).in_array(Rating::STATE_LIST)
  end

  [:customer, :book].each do |item|
    it "belongs to #{item}" do
      expect(rating).to belong_to item
    end
  end

  context "#custom_label_method" do
    it "returns string with rating description" do
      expect(rating.send(:custom_label_method)).
        to eq "rating #{rating.id} for book #{rating.book_id}"
    end
  end

  it_behaves_like 'state_enum testing', :rating
end
