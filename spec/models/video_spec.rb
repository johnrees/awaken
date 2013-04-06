require 'spec_helper'

describe Video do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:client) }
  it { should validate_presence_of(:kind) }
end
