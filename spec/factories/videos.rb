# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    name "MyString"
    kind "MyString"
    client "MyString"
    attachment { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test_video.flv')) }
  end
end
