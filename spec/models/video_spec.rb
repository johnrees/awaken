require 'spec_helper'

describe Video do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:client) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:attachment) }
  pending { should validate_presence_of(:zencoder_output_id) }
  it { should_not be_processed}

  it "should have highest ordinal on create" do
    Timecop.scale(3600)
    video1 = FactoryGirl.create(:video)
    video2 = FactoryGirl.create(:video)
    video2.ordinal.should > video1.ordinal
  end

end
