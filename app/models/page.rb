class Page < ActiveRecord::Base
  attr_accessible :content, :name, :permalink
  validates_presence_of :content, :name, :permalink
  validates_uniqueness_of :name, :permalink

  def to_param
    permalink
  end

  def to_s
    name
  end
end
