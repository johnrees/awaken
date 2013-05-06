require 'spec_helper'

describe "Videos" do

  it "should be deletable" do
    video = FactoryGirl.create(:video)
    visit admin_root_path
    click_link video.name
    click_link "Delete"
    page.should have_content "Video Deleted"
    page.should_not have_link(video.name)
  end

  it "should be editable" do
    video = FactoryGirl.create(:video)
    visit edit_admin_video_url(video)
    fill_in :video_name, with: "TESTING NAME"
    click_button "Update Video"
    page.should have_content "Video Updated"
    page.should have_link("TESTING NAME")
  end

  it "should be addable" do
    visit admin_videos_path
    click_link "Upload New Video"
    %w(video_kind video_name video_client).each do |att|
      fill_in att, with: 'test'
    end
    attach_file(:video_attachment, File.expand_path('spec/support/test_video.flv'))
    click_button "Add Video"
    page.should have_content "Video Added"
    page.should have_link "test"
  end

end
