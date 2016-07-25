shared_examples 'setting omniauth locale' do
  it "sets session[:omniauth_login_locale] equal to I18n.locale" do
    expect(controller.session[:omniauth_login_locale]).to eq I18n.locale
  end
end