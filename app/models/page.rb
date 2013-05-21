class Page < ActiveRecord::Base
  attr_accessible :content, :name, :permalink, :ordinal
  validates_presence_of :content, :name, :permalink
  validates_uniqueness_of :name, :permalink

  default_scope order('ordinal ASC')

  def to_param
    permalink
  end

  def to_s
    name
  end


  def self.do_order(ids)
    update_all(
      ["ordinal = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"],
      { :id => ids }
    )
  end

end
