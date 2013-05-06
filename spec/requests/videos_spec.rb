require 'spec_helper'

describe "Videos" do

  it "should be deletable" do
    video = FactoryGirl.create(:video)
    visit admin_root_path
    click_link video.name
    click_link "Delete"
    page.should_not have_link(video.name)
  end

  it "should be editable" do
    video = FactoryGirl.create(:video)
    visit edit_admin_video_url(video)
    fill_in :video_name, with: "TESTING NAME"
    click_button "Update Video"
    page.should have_link("TESTING NAME")
  end

end
