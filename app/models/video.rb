class Video < ActiveRecord::Base
  attr_accessible :client, :kind, :name, :attachment,
    :zencoder_output_id, :processed, :thumbnail
  validates_presence_of :client, :kind, :name, :attachment
  mount_uploader :attachment, VideoUploader

  def to_s
    name
  end

  def processed!
    update_attribute(:processed, true)
  end

end
