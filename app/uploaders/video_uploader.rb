class VideoUploader < CarrierWave::Uploader::Base
  include Rails.application.routes.url_helpers

  Rails.application.routes.default_url_options = ActionMailer::Base.default_url_options

  after :store, :zencode
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(mov avi mp4 mkv wmv mpg flv)
  end

  def filename
    "video.mp4" if original_filename
  end

  private

  def zencode(args)
    input = "s3://#{ENV['AWS_S3_BUCKET']}/uploads/video/attachment/#{@model.id}/video.mp4"
    base_url = "s3://#{ENV['AWS_S3_BUCKET']}/uploads/video/attachment/#{@model.id}"

    zencoder_response = Zencoder::Job.create({
      :input => input,
      :output => [{
        :base_url => base_url,
        :filename => "video.mp4",
        :label => "web",
        :notifications => [zencoder_callback_url(:protocol => 'http')],
        :video_codec => "h264",
        :audio_codec => "aac",
        :quality => 4,
        :width => 1024,
        :height => 768,
        :format => "mp4",
        :aspect_mode => "preserve",
        :public => 1
      }]
    })

    # Rails.logger.info(zencoder_response.inspect)

    zencoder_response.body["outputs"].each do |output|
      if output["label"] == "web"
        @model.zencoder_output_id = output["id"]
        @model.processed = false
        @model.save(:validate => false)
      end
    end
  end

end