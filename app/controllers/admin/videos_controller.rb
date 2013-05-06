require 'base64'

class Admin::VideosController < ApplicationController
  skip_before_filter :verify_authenticity_token#, :only => :upload
  layout "admin"

  def screenshot
    File.open('screenshot1.txt', "w+") do |f|
      f.write( params[:bitmapdata].split(',')[1] )
    end
    File.open('screenshot2.png', "wb") do |f|
      f.write( Base64.decode64(params[:bitmapdata].split(',')[1]) )
    end
    render text: 'done'
  end

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
    @videos = Video.order('ordinal ASC')
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
    if @video.save
      redirect_to admin_videos_url, notice: "Created Video"
    else
      render :new
    end
  end

  def show
    @video = Video.find(params[:id])
  end

  def sort
    params[:video].each_with_index do |id, index|
      Video.update_all({ordinal: index+1}, {id: id})
    end
    render nothing: true
  end

  def destroy
    @video = Video.find(params[:id])
    @video.delete
    redirect_to admin_videos_url, notice: "Deleted Video"
  end

end
