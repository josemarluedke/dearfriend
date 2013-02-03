# encoding: UTF-8
require 'spec_helper'

feature "Volunteer Login" do
  scenario "Receive an option to read volunteer responsabilities" do
    visit "/"
    click_on "Me cadastrar"
    verify_translations
    page.should have_content("Quando um dos membros deixa a Liga")
  end

  scenario "Create an account" do
    visit "/"
    click_on "Me cadastrar"
    fill_in "Nome", with: "Juquinha da Rocha"
    fill_in "E-mail", with: "juquinha@dearfriend.cc"
    fill_in "Senha", with: "123123"
    fill_in "Confirmação de senha", with: "123123"
    check "Eu quero fazer parte da Liga"
    within "form" do
      click_on "Me cadastrar"
    end
    verify_translations
    click_on "Meu perfil"
    verify_translations
    page.should have_css("#user_volunteer[checked]")
  end

  scenario "Don't receive 'future approval message' when updates its profile and already are a volunteer" do
    sign_in_via(:facebook, volunteer: true)
    click_on "Meu perfil"
    verify_translations
    check "Eu quero fazer parte da Liga"
    click_on "Atualizar"
    verify_translations
    page.should_not have_content("You're almost a volunteer. We just need verify your appliance.")
  end

  scenario "See its verified volunteer badge after admin approval" do
    sign_in_via(:facebook, volunteer: true, verified_volunteer: true)
    click_on "Meu perfil"
    page.should have_css("img#verified_volunteer")
  end

  scenario "Don't see its verified volunteer badge without receive admin approval" do
    sign_in_via(:facebook, volunteer: true)
    click_on "Meu perfil"
    page.should_not have_css("img#verified_volunteer")
  end
end
