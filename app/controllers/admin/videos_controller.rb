class Admin::VideosController < ApplicationController
  skip_before_filter :verify_authenticity_token#, :only => :upload
  layout "admin"

  def index
    @videos = Video.all
  end

  def new
    @video = Video.new
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
