class Video < ActiveRecord::Base
  attr_accessible :client, :kind, :name
  validates_presence_of :client, :kind, :name
end
