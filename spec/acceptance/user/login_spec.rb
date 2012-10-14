require "spec_helper"

feature "User Login" do
  context "without using any provider" do
    scenario "Create an account" do
      visit "/"
      click_on "Sign Up"
      fill_in "Name", with: "Juquinha da Rocha"
      fill_in "E-mail", with: "juquinha@dearfriend.cc"
      fill_in "Password", with: "123123"
      fill_in "Password confirmation", with: "123123"
      within "form" do
        click_on "Sign Up"
      end
      page.should have_content("Welcome! You have signed up successfully.")
    end

    scenario "Login" do
      User.make!(email: "juquinha@dearfriend.cc", password: "123123", password_confirmation: "123123")
      visit "/"
      click_on "Sign In"
      fill_in "E-mail", with: "juquinha@dearfriend.cc"
      fill_in "Password", with: "123123"
      within "form" do
        click_on "Sign In"
      end
      page.should have_content("Signed in successfully.")
    end

    scenario "Logout" do
      User.make!(email: "juquinha@dearfriend.cc", password: "123123", password_confirmation: "123123")
      visit "/"
      click_on "Sign In"
      fill_in "E-mail", with: "juquinha@dearfriend.cc"
      fill_in "Password", with: "123123"
      within "form" do
        click_on "Sign In"
      end
      click_on "Sign Out"
      page.should have_content("Signed out successfully.")
    end
  end

  context "with Facebook" do
    scenario "Create an account" do
      sign_in_via(:facebook)
      page.should have_content("Welcome! You have signed up successfully.")
    end

    scenario "Login" do
      sign_in_via(:facebook)
      click_on "Sign Out"

      visit "/"
      click_on "Sign In"
      click_on "Sign in with Facebook"
      page.should have_content("You are already signed in.")
    end

    scenario "Logout" do
      sign_in_via(:facebook)
      click_on "Sign Out"
      page.should have_content("Signed out successfully.")
    end
  end

  context "with Twitter" do
    scenario "Create an account" do
      sign_in_via(:twitter)
      page.should have_content("Welcome! You have signed up successfully.")
    end

    scenario "Login" do
      sign_in_via(:twitter)
      click_on "Sign Out"

      visit "/"
      click_on "Sign In"
      click_on "Sign in with Twitter"
      page.should have_content("You are already signed in.")
    end

    scenario "Logout" do
      sign_in_via(:twitter)
      click_on "Sign Out"
      page.should have_content("Signed out successfully.")
    end
  end

  scenario "Logged user authorizes Facebook account" do
    sign_in_via(:twitter)
    click_on "Juquinha da Rocha"
    click_on "Profile settings"
    auth_omniauth(:facebook)
    click_on "Connect your Facebook"
    page.should have_content("Disconnect from Facebook")
  end

  scenario "Logged user authorizes Twitter account" do
    sign_in_via(:facebook)
    click_on "Profile settings"
    auth_omniauth(:twitter)
    click_on "Connect your Twitter"
    page.should have_content("Disconnect from Twitter")
  end

  scenario "Become a volunteer and receive a message demonstrating the future approval" do
    sign_in_via(:facebook)
    click_on "Profile settings"
    check "Volunteer?"
    click_on "Update"
    page.should have_content("You're almost a volunteer. We just need verify your appliance.")
  end
end
