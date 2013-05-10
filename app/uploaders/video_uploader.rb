class VideoUploader < CarrierWave::Uploader::Base
  include Rails.application.routes.url_helpers
  Rails.application.routes.default_url_options = ActionMailer::Base.default_url_options

  unless Rails.env.test?
    after :store, :zencode
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(mov avi mp4 mkv wmv mpg flv)
  end

  # def filename
  #   "video.mp4" if original_filename
  # end

  private

  def zencode(args)
    base_url = "s3://#{ENV['AWS_S3_BUCKET']}/uploads/video/attachment/#{@model.id}"
    input = "#{base_url}/#{original_filename}"

    notification_url = Rails.env.production? ? "http://rouse.johnre.es/zencoder-callback" : "http://rouse.pagekite.me/zencoder-callback"

    zencoder_response = Zencoder::Job.create({
      :input => input,
      :outputs => [
        {
          :base_url => base_url,
          :filename => "video.webm",
          :size => "1920x1080",
          :public => 1
        },
        {
          :base_url => base_url,
          :filename => "video.ogg",
          :size => "1920x1080",
          :public => 1
        },
        {
          :base_url => base_url,
          :filename => "video-small.mp4",
          :size => "640x480",
          :public => 1
        },
        {
        :base_url => base_url,
        :filename => "video.mp4",
        :size => "1920x1080",
        :label => "web",
        :notifications => [
            # zencoder_callback_url(:protocol => 'http')
            notification_url
        ],
        :video_codec => "h264",
        :audio_codec => "aac",
        :quality => 4,
        :format => "mp4",
        :aspect_mode => "preserve",
        :public => 1,
        :thumbnails => [
          {
            :base_url => base_url,
            :format => "jpg",
            :label => "thumb",
            :number => 20,
            :width => 330,
            :height => 250,
            :aspect_mode => "crop",
            :filename => "thumbnail_{{number}}",
            # :filename => "poster",
            # :times => [ params[:time].to_f * 100 ],
            :public => 1
          },
          {
            :base_url => base_url,
            :format => "jpg",
            :label => "poster",
            :number => 20,
            :filename => "poster_{{number}}",
            :public => 1
          }
        ]
      }]
    })

    # Rails.logger.info(zencoder_response.inspect)

    zencoder_response.body["outputs"].each do |output|
      if output["label"] == "web"
        @model.zencoder_output_id = output["id"]
        @model.thumbnail = "http://#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com/uploads/video/attachment/#{@model.id}/thumbnail_4.jpg"
        @model.processed = false
        @model.save(:validate => false)
      end
    end
  end

end
