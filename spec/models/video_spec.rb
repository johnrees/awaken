require 'spec_helper'

describe Video do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:client) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:attachment) }
  pending { should validate_presence_of(:zencoder_output_id) }
  it { should_not be_processed}
end
