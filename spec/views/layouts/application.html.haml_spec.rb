require 'rails_helper'

describe 'layouts/application.html.haml' do

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

  let(:customer) { FactoryGirl.create :customer }
  let(:admin) { FactoryGirl.create :admin }

  before do
    allow(view).to receive(:cart_caption)
    allow(view).to receive(:url_for).and_return(root_path)
  end

  context 'unauthentified user' do
    before do
      allow(view).to receive(:current_admin) { nil }
      allow(view).to receive(:current_customer) { nil }
      render
    end
    
    it_behaves_like 'any user'

    [:sign_in, :sign_up].each do |link|
      it_behaves_like 'has link', link
    end
  end
  
  context 'authentified customer' do
    before do
      allow(controller).to receive(:current_admin) { nil }
      allow(controller).to receive(:current_customer) { customer }
      render
    end

    it_behaves_like 'any user'
    it_behaves_like 'has link', :sign_out
    it_behaves_like 'has link', :settings
  end

  context 'authentified admin' do
    before do
      allow(controller).to receive(:current_admin) { admin }
      allow(controller).to receive(:current_customer) { nil }
      render
    end

    it_behaves_like 'any user'
    it_behaves_like 'has link', :sign_out
    it_behaves_like 'has link', :admin_panel
  end
end