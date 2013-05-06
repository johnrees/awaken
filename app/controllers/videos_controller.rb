class VideosController < ApplicationController

  def index
    @videos = Video.order('ordinal ASC')
  end

  def show
    @video = Video.find(params[:id])
  end
end
