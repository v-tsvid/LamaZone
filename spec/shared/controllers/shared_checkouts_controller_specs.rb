shared_examples "new checkout form" do
  it "receives :new on CheckoutForm" do
    expect(CheckoutForm).to receive(:new).with(order)
    subject
  end
end

shared_examples "setting up wizard" do
  it "receives :setup_wizard" do
    expect(controller).to receive(:setup_wizard)
    subject
  end
end