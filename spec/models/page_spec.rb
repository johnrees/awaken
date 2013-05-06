require 'spec_helper'

describe Page do
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:permalink) }
  it { should validate_uniqueness_of(:permalink) }

  it "should have to_s" do
    FactoryGirl.build(:page, name: 'talk').to_s.should eq('talk')
  end
end
