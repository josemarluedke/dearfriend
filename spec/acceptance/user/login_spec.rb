# encoding: UTF-8
require "spec_helper"

feature "User Login" do
  context "without using any provider" do
    scenario "Create an account" do
      visit "/"
      verify_translations
      click_on "Me cadastrar"
      verify_translations
      fill_in "Nome", with: "Juquinha da Rocha"
      fill_in "E-mail", with: "juquinha@dearfriend.cc"
      fill_in "Senha", with: "123123"
      fill_in "Confirmação de senha", with: "123123"
      within "form" do
        click_on "Me cadastrar"
      end
      verify_translations
      page.should have_content("Seu cadastro foi feito com sucesso")
    end

    scenario "Login" do
      User.make!(email: "juquinha@dearfriend.cc", password: "123123", password_confirmation: "123123")
      visit "/"
      click_on "Login"
      verify_translations
      fill_in "E-mail", with: "juquinha@dearfriend.cc"
      fill_in "Senha", with: "123123"
      within "form" do
        click_on "Login"
      end
      verify_translations
      page.should have_content("Login feito com sucesso")
    end

    scenario "Logout" do
      User.make!(email: "juquinha@dearfriend.cc", password: "123123", password_confirmation: "123123")
      visit "/"
      click_on "Login"
      fill_in "E-mail", with: "juquinha@dearfriend.cc"
      fill_in "Senha", with: "123123"
      within "form" do
        click_on "Login"
      end
      click_on "Sair"
      verify_translations
      page.should have_content("Sessão encerrada")
    end
  end

  context "with Facebook" do
    scenario "Create an account" do
      sign_in_via(:facebook)
      page.should have_content("Seu cadastro foi feito com sucesso")
    end

    scenario "Login" do
      sign_in_via(:facebook)
      click_on "Sair"

      visit "/"
      click_on "Login"
      click_on "Logar com Facebook"
      page.should have_content("Você já está logado")
    end

    scenario "Logout" do
      sign_in_via(:facebook)
      click_on "Sair"
      page.should have_content("Sessão encerrada")
    end
  end

  context "with Twitter" do
    scenario "Create an account" do
      sign_in_via(:twitter)
      page.should have_content("Seu cadastro foi feito com sucesso")
    end

    scenario "Login" do
      sign_in_via(:twitter)
      click_on "Sair"

      visit "/"
      click_on "Login"
      click_on "Logar com Twitter"
      verify_translations
      page.should have_content("Você já está logado")
    end

    scenario "Logout" do
      sign_in_via(:twitter)
      click_on "Sair"
      page.should have_content("Sessão encerrada")
    end
  end

  scenario "Logged user authorizes Facebook account" do
    sign_in_via(:twitter)
    click_on "Juquinha da Rocha"
    click_on "Meu perfil"
    auth_omniauth(:facebook)
    click_on "Conecte seu Facebook"
    page.should have_content("Desconectar de Facebook")
  end

  scenario "Logged user authorizes Twitter account" do
    sign_in_via(:facebook)
    click_on "Meu perfil"
    auth_omniauth(:twitter)
    click_on "Conecte seu Twitter"
    page.should have_content("Desconectar de Twitter")
  end

  # scenario "Become a volunteer and receive a message demonstrating the future approval" do
  #   sign_in_via(:facebook)
  #   click_on "Profile settings"
  #   fill_in "Name", with: "Juquinha da Rocha"
  #   fill_in "E-mail", with: "juquinha@dearfriend.cc"
  #   fill_in "Current password", with: "123123"
  #   check "I want to be a volunteer"
  #   click_on "Update"
  #   page.should have_content("You're almost a volunteer. We just need verify your appliance.")
  # end
end
