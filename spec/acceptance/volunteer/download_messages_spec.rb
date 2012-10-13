require 'spec_helper'

feature "Download messages" do
  background do
    user = sign_in_via(:facebook)
    user.stub(:active_volunteer?).and_return(true)
    @project = Project.make!
    3.times { Message.make!(project: @project) }
  end

  scenario "Receive a message if all the messages were already downloaded"

  scenario "Don't be allowed to download more than the messages available"

  scenario "Select some quantity of messages to download" do
    visit "/"
    within ".project-box"do
      click_on "See more!"
    end
    fill_in "Quantity", with: "3"
    click_on "Download"
    page.should have_content("Download started!")
  end
end
