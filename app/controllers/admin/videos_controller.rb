class Admin::VideosController < ApplicationController
  layout "admin"
  def index
    @videos = Video.all
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])
    if @video.save
      redirect_to admin_videos_path, notice: "Video Created"
    else
      render :new
    end
  end
end
