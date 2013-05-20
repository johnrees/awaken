class VideosController < ApplicationController

  def index
    @videos = Video.published
  end

  def ios
    @videos = Video.published
  end

  def show
    @video = Video.find(params[:id])
  end

  def processed
    @video = Video.find(params[:id])
    render json: @video.processed?
  end

end
