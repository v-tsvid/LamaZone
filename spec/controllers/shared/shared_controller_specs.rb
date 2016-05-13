shared_examples "customer authentication" do
  it "receives authenticate_customer!" do
    expect(controller).to receive(:authenticate_customer!)
    subject
  end
end

shared_examples "load and authorize resource" do
  it "receives authorize!" do
    expect(controller).to receive(:authorize!)
    subject
  end
end