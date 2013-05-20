class Video < ActiveRecord::Base
  attr_accessible :client, :kind, :name, :attachment,
    :zencoder_output_id, :processed, :thumbnail, :ordinal
    # :width, :height, :filesize, :duration

  mount_uploader :attachment, VideoUploader
  validates_presence_of :client, :kind, :name, :attachment, on: :update
  validates_presence_of :attachment
  # before_create :set_position

  before_create :default_name
  def default_name
    self.name ||= File.basename(attachment.filename, '.*') if attachment
  end

  def self.do_order(ids)
    # update_all(
    #   ['ordinal = FIND_IN_SET(id, ?)', ids.join(',')],
    #   { :id => ids }
    # )
    update_all(
      ["ordinal = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"],
      { :id => ids }
    )
  end

  def self.disable(ids)
    update_all(
      ["ordinal = NULL"],
      { :id => ids }
    )
  end

  def ready?
    zencoder_output_id.present?
  end

  def self.published
    # where{(kind != "") && (client != "") && (name != "")}.order('ordinal')
    # where("kind <> '' AND client <> '' AND name <> '' AND ordinal > 0").order('ordinal')
    where('ordinal > 0').order('ordinal ASC')
  end

  def self.unpublished
    # where{(kind == nil) | (client == nil) | (name == nil)}
    # where('ordinal <= 0 OR ordinal = NULL')
    where({ordinal: nil}).order('updated_at DESC')
  end

  def video
    thumbnail.gsub(/thumbnail_(\d+).jpg/, 'video.mp4')
  end

  def to_param
    "#{id}-#{name.parameterize}"
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
