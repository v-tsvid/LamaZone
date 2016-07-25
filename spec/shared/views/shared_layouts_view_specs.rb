shared_examples 'has link' do |link|
  it "has link \"#{I18n.t(link)}\"" do
    expect(rendered).to have_link I18n.t(link)
  end
end

shared_examples 'any user' do
  before { render }

  it "has the title \"LamaZone\"" do
    expect(rendered).to have_title 'LamaZone'
  end

  it 'has the brand logo' do
    expect(rendered).to have_css "img[alt='LZ']"
  end

  it "has link \"Books\"" do
    expect(rendered).to have_link 'SHOP'
  end
end