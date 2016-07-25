shared_examples "errors displaying" do |item|

  it "displays error message if #{item} has an error" do
    allow(@customer).to receive_message_chain("errors.messages") {
      { item => ["some_#{item}_error", "another_#{item}_error"]} }
    
    render
    expect(rendered).to have_selector(
      ".help-block", text:"some_#{item}_error, another_#{item}_error")
  end
end

shared_examples "address fields displaying" do
  
  it "displays header for address fields" do
    expect(rendered).to match "#{subject.upcase} ADDRESS"
  end

  [:firstname, 
   :lastname, 
   :phone, 
   :address1, 
   :address2, 
   :city, 
   :zipcode].each do |item|
    it "displays fields for address #{item}" do
      expect(rendered).to have_selector(
        ".#{subject}_address_form input[type=text][id='address_#{spaced(item)}']")
    end
  end

  it "displays select for address country" do
    expect(rendered).to have_selector(
      ".#{subject}_address_form select[id='address_country_id']")
  end

  it "displays SAVE button" do
    expect(rendered).to have_selector(
      ".#{subject}_address_form input[type=submit][value='SAVE']")
  end
end

shared_examples "fields displaying" do |with_errors|

  before do
    @customer = assign(:resource, FactoryGirl.build_stubbed(:customer))
  end

  [:email, :password, :password_confirmation].each do |item|

    if with_errors == true
      it "displays field for new customer's #{spaced(item)} with errors" do

        allow(@customer).to receive_message_chain("errors.messages") {
          { item => ["some_#{item}_error", "another_#{item}_error"]} }
      
        render
        expect(rendered).to have_selector(
          ".has-error input[id='customer_#{item.to_s}']")  
        expect(rendered).to have_selector(
          ".help-block", text:"some_#{item}_error, another_#{item}_error")
      end
    else
      it "displays field for new customer's #{spaced(item)}" do
        expect(rendered).to have_selector("div input[id='customer_#{item.to_s}']")  
      end
    end  
  end
end