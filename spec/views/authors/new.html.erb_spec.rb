require 'rails_helper'

RSpec.describe "authors/new", type: :view do
  before(:each) do
    assign(:author, Author.new(
      :firstname => "MyString",
      :lastname => "MyString",
      :biography => "MyText"
    ))
  end

  it "renders new author form" do
    render

    assert_select "form[action=?][method=?]", authors_path, "post" do

      assert_select "input#author_firstname[name=?]", "author[firstname]"

      assert_select "input#author_lastname[name=?]", "author[lastname]"

      assert_select "textarea#author_biography[name=?]", "author[biography]"
    end
  end
end
