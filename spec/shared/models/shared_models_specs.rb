shared_examples 'state_enum testing' do |klass|
  let(:object) { FactoryGirl.create(klass) }
  subject { object.state_enum }

  it "returns STATE_LIST" do
    expect(subject).to eq object.class::STATE_LIST
  end
end