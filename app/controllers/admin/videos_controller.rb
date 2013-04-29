class Admin::VideosController < ApplicationController
  skip_before_filter :verify_authenticity_token#, :only => :upload
  layout "admin"

  def thumbnail
    base_url = "s3://#{ENV['AWS_S3_BUCKET']}/uploads/video/attachment/#{params[:id]}"
    input = "#{base_url}/video.mp4"

    zencoder_response = Zencoder::Job.create({
      :input => input,
      :output => [{
        :thumbnails => [
          {
            :base_url => base_url,
            :format => "jpg",
            :label => "thumb",
            :filename => "poster",
            :times => [ params[:time].to_f * 100 ],
            :public => 1
          }
        ]
      }]
    })

    render text: zencoder_response.inspect

  end

  def index
    @videos = Video.all
  end

  def new
    @video = Video.new
  end

  def edit
    @video = Video.find(params[:id])
  end

  def update
    @video = Video.find(params[:id])
    if @video.update_attributes(params[:video])
      redirect_to admin_videos_path, notice: "Updated Video"
    else
      render :edit
    end
  end

  def create
    @video = Video.new(params[:video])
    # if @video.save
    #   redirect_to admin_videos_path, notice: "Video Created"
    # else
    #   render :new
    # end
    if @video.save
      render :text =>  "=> true"
    else
      render :nothing => true, :status => 400
    end
  end

  def show
    @video = Video.find(params[:id])
  end
end
