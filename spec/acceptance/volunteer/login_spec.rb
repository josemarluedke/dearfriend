require 'spec_helper'

feature "Volunteer Login" do
  scenario "Receive an option to read volunteer responsabilities" do
    visit "/"
    click_on "Sign Up"
    verify_translations
    page.should have_content("When a verified volunteer gives up")
  end

  scenario "Create an account" do
    visit "/"
    click_on "Sign Up"
    fill_in "Name", with: "Juquinha da Rocha"
    fill_in "E-mail", with: "juquinha@dearfriend.cc"
    fill_in "Password", with: "123123"
    fill_in "Password confirmation", with: "123123"
    check "I want to be a volunteer"
    within "form" do
      click_on "Sign Up"
    end
    verify_translations
    click_on "Profile settings"
    verify_translations
    page.should have_css("#user_volunteer[checked]")
  end

  scenario "Don't receive 'future approval message' when updates its profile and already are a volunteer" do
    sign_in_via(:facebook, volunteer: true)
    click_on "Profile settings"
    verify_translations
    check "I want to be a volunteer"
    click_on "Update"
    verify_translations
    page.should_not have_content("You're almost a volunteer. We just need verify your appliance.")
  end

  scenario "See its verified volunteer badge after admin approval" do
    sign_in_via(:facebook, volunteer: true, verified_volunteer: true)
    click_on "Profile settings"
    page.should have_css("img#verified_volunteer")
  end

  scenario "Don't see its verified volunteer badge without receive admin approval" do
    sign_in_via(:facebook, volunteer: true)
    click_on "Profile settings"
    page.should_not have_css("img#verified_volunteer")
  end
end
