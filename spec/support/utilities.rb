def admin_panel_edit_link(str)
  "a.pjax[href=\"/admin/#{str}/edit\?locale=en\"]"
end

def admin_panel_show_link(str)
  "a.pjax[href=\"/admin/#{str}\?locale=en\"]"
end

def admin_panel_custom_action_link(str, action)
  "a.pjax[href=\"/admin/#{str}/#{action}\?locale=en\"]"
end

def setup_ability
  @ability = Object.new
  @ability.extend(CanCan::Ability)
  allow(controller).to receive(:current_ability).and_return(@ability)
  @ability.can :manage, :all
end


def stringify_hash(hash)
  hash.inject(hash){ |h,(key,val)| h[key]=val.to_s; h }.stringify_keys
end

def spaced(symbol)
  symbol.to_s.tr('_', ' ')
end

def sign_in_via_capybara(user)
  user.class == Admin ? visit(admin_session_path) : visit(customer_session_path)

  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def valid_facebook_sign_in(opts = {})
  default = {:provider => :facebook,
             :uuid     => "580001345483302",
             :facebook => {
                            :email => "vad_1989@mail.ru",
                            :first_name => "Vadim",
                            :last_name => "Tsvid"
                          }
            }

  credentials = default.merge(opts)
  provider = credentials[:provider]
  user_hash = credentials[provider]

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
    :provider => credentials[:provider].to_s,
    :uid => credentials[:uuid],
    :info => {
      :email => user_hash[:email],
      :first_name => user_hash[:first_name],
      :last_name => user_hash[:last_name],
    }
  })
end

def invalid_facebook_sign_in(opts = {})

  credentials = { :provider => :facebook,
                  :invalid  => :invalid_credentials
                 }.merge(opts)

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]

end

def silence_omniauth
  previous_logger = OmniAuth.config.logger
  OmniAuth.config.logger = Logger.new("/dev/null")
  yield
ensure
  OmniAuth.config.logger = previous_logger
end