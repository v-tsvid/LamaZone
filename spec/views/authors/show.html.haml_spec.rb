require 'rails_helper'

RSpec.describe "authors/show", type: :view do

  before do
    @author = assign(:author, stub_model(Author,  firstname: "Firstname",
                                                  lastname: "Lastname",
                                                  biography: "Biography"))
    render
  end
  
  [:firstname, :lastname, :biography].each do |item|
    it "displays author's #{spaced(item)}" do
      expect(rendered).to have_selector 'p', text: @author.send(item)
    end
  end

  it "displays back to shopping button" do
    expect(rendered).to have_link 'BACK TO SHOPPING', href: books_path
  end
end
