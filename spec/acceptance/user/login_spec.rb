require "spec_helper"

feature "Login" do
  scenario "Create an account without using any provider" do
    visit "/"
    click_on "Sign Up"
    fill_in "Name", with: "Juquinha da Rocha"
    fill_in "E-mail", with: "juquinha@dearfriend.cc"
    fill_in "Password", with: "123123"
    fill_in "Password confirmation", with: "123123"
    click_on "Sign Up"
    page.should have_content("Welcome! You have signed up successfully.")
  end

  scenario "Login without using any provider" do
    User.make!(email: "juquinha@dearfriend.cc", password: "123123", password_confirmation: "123123")
    visit "/"
    click_on "Sign In"
    fill_in "E-mail", with: "juquinha@dearfriend.cc"
    fill_in "Password", with: "123123"
    click_on "Sign In"
    page.should have_content("Signed in successfully.")
  end
end
