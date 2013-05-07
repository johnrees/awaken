class Video < ActiveRecord::Base
  attr_accessible :client, :kind, :name, :attachment,
    :zencoder_output_id, :processed, :thumbnail, :ordinal

  mount_uploader :attachment, VideoUploader
  validates_presence_of :client, :kind, :name, :attachment, on: :update
  validates_presence_of :attachment
  # before_create :set_position

  before_create :default_name
  def default_name
    self.name ||= File.basename(attachment.filename, '.*') if attachment
  end

  def ready?
    zencoder_output_id.present?
  end

  def poster
    thumbnail.gsub('thumbnail', 'poster')
  end

  def thumbnails
    arr = []
    (0..19).each do |thumb|
      arr.push "http://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com/uploads/video/attachment/#{id}/thumbnail_#{thumb}.jpg"
    end
    return arr
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
