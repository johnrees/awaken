class Video < ActiveRecord::Base
  attr_accessible :client, :kind, :name, :attachment,
    :zencoder_output_id, :processed, :thumbnail, :ordinal

  mount_uploader :attachment, VideoUploader
  validates_presence_of :client, :kind, :name, :attachment
  # before_create :set_position

  def ready?
    zencoder_output_id.present?
  end

  def to_s
    name
  end

  def processed!
    update_attribute(:processed, true)
  end

private

  def set_position
    self.ordinal = Time.now.to_i
  end

end
