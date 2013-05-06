require 'spec_helper'

describe "Pages" do

  before(:all) do

    @pages = %w[Awards Biography Contact]
    @pages.each do |p|
      Page.create(name: p, permalink: p.downcase, content: 'initial content')
    end
  end

  it "should have link" do
    @pages.each do |p|
      visit root_path
      page.should have_link(p)
    end
  end

  it "should be editable" do
    @pages.each do |p|
      visit admin_root_path
      click_link p
      fill_in :page_content, with: "Testing"
      click_button "Save Changes"
      page.should have_content "Page Updated"
      visit root_path
      click_link p
      page.should have_content "Testing"
    end
  end

end
