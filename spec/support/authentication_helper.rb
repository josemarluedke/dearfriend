# encoding: UTF-8
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
    click_on "Me cadastrar"
    click_on "Logar com #{provider.to_s.humanize}"
    fill_in "Senha", with: "123123"
    fill_in "Confirmação de senha", with: "123123"
    check "Eu quero fazer parte da Liga" if attrs[:volunteer]
    within "form" do
      click_on "Me cadastrar"
    end
    if attrs[:verified_volunteer]
      user = User.find_by_email(user["info"]["email"])
      user.verified_volunteer = true
      user.volunteer = true
      user.save
    end

    user
  end
end
