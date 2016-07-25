shared_context "stub helpers and render" do
  before do
    allow(view).to receive(:cool_price)
    allow(view).to receive(:cool_date)
    render 
  end
end