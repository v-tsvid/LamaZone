require 'rails_helper'

RSpec.describe "authors/edit", type: :view do
  before(:each) do
    @author = assign(:author, Author.create!(
      :firstname => "MyString",
      :lastname => "MyString",
      :biography => "MyText"
    ))
  end

  it "renders the edit author form" do
    render

    assert_select "form[action=?][method=?]", author_path(@author), "post" do

      assert_select "input#author_firstname[name=?]", "author[firstname]"

      assert_select "input#author_lastname[name=?]", "author[lastname]"

      assert_select "textarea#author_biography[name=?]", "author[biography]"
    end
  end
end
