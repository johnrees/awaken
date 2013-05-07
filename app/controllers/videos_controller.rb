class VideosController < ApplicationController

  def index
    @videos = Video.order('ordinal ASC')
  end

  def show
    @video = Video.find(params[:id])
  end

  def processed
    @video = Video.select(nil).find(params[:id])
    render json: @video.processed?
  end

end
