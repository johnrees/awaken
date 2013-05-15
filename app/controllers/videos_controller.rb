class VideosController < ApplicationController

  def index
    @videos = Video.where{ordinal != nil}.order('ordinal ASC')
  end

  def ios
    @videos = Video.where{ordinal != nil}.order('ordinal ASC')
  end

  def show
    @video = Video.find(params[:id])
  end

  def processed
    @video = Video.find(params[:id])
    render json: @video.processed?
  end

end
