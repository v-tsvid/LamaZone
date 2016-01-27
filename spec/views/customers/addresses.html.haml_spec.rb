require 'rails_helper'

RSpec.describe "customers/addresses.html.haml", type: :view do
 before(:each) do
    @customer = stub_model(Customer)
    @country_ids = ['1', '2']
    assign(:addresses, [stub_model(Address,
                        contact_name: 'Smith', 
                        phone: '380930000001',
                        address1: 'address1 line',
                        address2: 'address2 line',
                        city: 'Gotham City',
                        zipcode: '1234',
                        country_id: @country_ids[0]
                        ),
                      stub_model(Address,
                        contact_name: 'Doe', 
                        phone: '380930000002',
                        address1: 'address1 line',
                        address2: 'address2 line',
                        city: 'Goddamn City',
                        zipcode: '5678',
                        country_id: @country_ids[1])])
    
    allow(controller).to receive(:current_customer).and_return(@customer.id)
    
    render template: "customers/addresses.html.haml"
  end

  it "renders address partial" do
    expect(view).to render_template(partial: '_address', count: 2)
  end

  it "displays address' contact_name" do
    expect(rendered).to match /Smith/
    expect(rendered).to match /Doe/
  end

  it "displays address' phone" do
    expect(rendered).to match /380930000001/
    expect(rendered).to match /380930000002/
  end

  it "displays address' address1" do
    assert_select "tr>td", text: 'address1 line', count: 2
  end

  it "displays address' address2" do
    assert_select "tr>td", text: 'address2 line', count: 2
  end

  it "displays address' zipcode" do
    expect(rendered).to match /1234/
    expect(rendered).to match /5678/
  end

  it "displays address' city" do
    expect(rendered).to match /Gotham City/
    expect(rendered).to match /Goddamn City/
  end

  it "displays address' country name" do
    expect(rendered).to match Country.find(@country_ids[0]).name
    expect(rendered).to match Country.find(@country_ids[1]).name
  end

  it "displays link to new customer's address" do
    expect(rendered).to have_selector(
      "a[href=\"#{new_customer_address_path(@customer)}\"]", text: 'New Address')
  end
end
