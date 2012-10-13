require 'spec_helper'

feature "Volunteer Login" do
  scenario "Receive an option to read volunteer responsabilities" do
    visit "/"
    click_on "Sign Up"
    page.should have_content("Volunteer's responsabilities")
  end

  scenario "Create an account" do
    visit "/"
    click_on "Sign Up"
    fill_in "Name", with: "Juquinha da Rocha"
    fill_in "E-mail", with: "juquinha@dearfriend.cc"
    fill_in "Password", with: "123123"
    fill_in "Password confirmation", with: "123123"
    check "Volunteer?"
    within "form" do
      click_on "Sign Up"
    end

    click_on "Edit profile"
    page.should have_css("#user_volunteer[checked]")
  end

  scenario "Don't receive 'future approval message' when updates its profile and already are a volunteer" do
    sign_in_via(:facebook, volunteer: true)
    click_on "Edit profile"
    check "Volunteer?"
    click_on "Update"
    page.should_not have_content("You're almost a volunteer. We just need verify your appliance.")
  end

  scenario "See its verified volunteer badge after admin approval" do
    sign_in_via(:facebook, volunteer: true, verified_volunteer: true)
    click_on "Edit profile"
    page.should have_css("img#verified_volunteer")
  end

  scenario "Don't see its verified volunteer badge without receive admin approval" do
    sign_in_via(:facebook, volunteer: true)
    click_on "Edit profile"
    page.should_not have_css("img#verified_volunteer")
  end
end
