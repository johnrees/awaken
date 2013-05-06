class Video < ActiveRecord::Base
  attr_accessible :client, :kind, :name, :attachment,
    :zencoder_output_id, :processed, :thumbnail
  validates_presence_of :client, :kind, :name, :attachment
  mount_uploader :attachment, VideoUploader

  before_create :set_position

  def to_s
    name
  end

  def processed!
    update_attribute(:processed, true)
  end

private

  def set_position
    ordinal = Time.now.to_i
  end

end
