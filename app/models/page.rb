class Page < ActiveRecord::Base
  attr_accessible :content, :name, :permalink
  validates_presence_of :content, :name, :permalink

  def to_param
    permalink
  end
end
