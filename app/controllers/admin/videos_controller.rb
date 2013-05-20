require 'base64'

class Admin::VideosController < ApplicationController
  skip_before_filter :verify_authenticity_token#, :only => :upload
  layout "admin"

  def sort
    order = params[:video]
    Video.do_order(order)
    render :text => order.inspect
  end

  def disable
    videos = params[:video]
    Video.disable(videos)
    render :text => videos.inspect
  end

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
        :skip_audio => true,
        :clip_length => 1,
        :start_clip => params[:time].to_f,
        :thumbnails => [
          {
            :base_url => base_url,
            :format => "jpg",
            :label => "thumb",
            :filename => "poster",
            :times => [ params[:time].to_f * 100 ],
            # :start_at_first_frame => true,
            :number => 1,
            :public => true
          }
        ]
      }]
    })

    render text: zencoder_response.inspect

  end

  def index
    @videos = Video.order('id DESC')
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
      redirect_to admin_videos_path, notice: "Video Updated"
    else
      render :edit
    end
  end

  def create
    @video = Video.create(params[:video])
    # @video = Video.new(params[:video])
    # if @video.save!
    #   redirect_to admin_videos_url, notice: "Video Added"
    # else
    #   # render :new
    #   render text: params.inspect
    # end
  end

  def show
    @video = Video.find(params[:id])
  end

  # def sort
  #   params[:video].each_with_index do |id, index|
  #     Video.update_all({ordinal: index+1}, {id: id})
  #   end
  #   render nothing: true
  # end

  def update_homepage
    Video.update_all(ordinal: nil)
    unless params[:video].empty?
      params[:video].each_with_index do |video_number, index|
        video = Video.select('id').find(video_number.to_i)
        video.update_attribute(:ordinal, index)
      end
    end
    render text: params[:video].inspect
  end

  def edit_order
    @videos = Video.select('id, name, ordinal')
  end

  def destroy
    @video = Video.find(params[:id])
    @video.delete
    redirect_to admin_videos_url, notice: "Video Deleted"
  end

end
