require 'spec_helper'

feature "Download messages" do
  background do
    user = sign_in_via(:facebook)
    User.any_instance.stub(:active_volunteer?).and_return(true)
    @project = Project.make!
  end

  scenario "Don't view the 'Download messages' link if all the messages were already downloaded" do
    visit "/"
    within ".project-box"do
      click_on "See more!"
    end
    within ".buttons" do
      page.should_not have_content("Download messages")
    end
  end

  scenario "Don't be allowed to download more than the messages available" do
    3.times { Message.make!(project: @project) }

    visit "/"
    within ".project-box"do
      click_on "See more!"
    end
    click_on "Download messages"
    fill_in "messages_quantity", with: "4"
    click_on "Download"
    page.should have_content("There is just 3 messages to be downloaded.")
  end

  scenario "Select some quantity of messages to download" do
    3.times { Message.make!(project: @project) }

    visit "/"
    within ".project-box"do
      click_on "See more!"
    end
    click_on "Download messages"
    fill_in "messages_quantity", with: "3"
    click_on "Download"
    page.should have_content("Download started!")
  end
end