require "spec_helper"

module AuthenticationHelper
  def auth_omniauth(provider, user_info = {})
    user_info = { name: "Juquinha da Rocha", email: "juquinha@dearfriend.cc" }.merge(user_info)

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
       :provider => provider,
       :uid => '123123',
       :info => user_info,
       :credentials => {
         :token => "qweqwe"
       }
     )
  end

  def sign_in_via(provider, attrs = {}, volunteer = false)
    user = auth_omniauth(provider, attrs)

    visit "/"
    click_on "Sign Up"
    click_on "Login with #{provider.to_s.humanize}"
    fill_in "Password", with: "123123"
    fill_in "Password confirmation", with: "123123"
    check "Volunteer?" if attrs[:volunteer]
    within "form" do
      click_on "Sign Up"
    end
    if attrs[:verified_volunteer]
      user = User.find_by_email(user["info"]["email"])
      user.verified_volunteer = true
      user.save
    end

    user
  end
end
