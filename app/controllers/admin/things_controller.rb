class Admin::ThingsController < ApplicationController

  def set_initial_position
    @thing = Thing.first || Thing.create
    @thing.update_attribute(position: params[:position])
  end

end