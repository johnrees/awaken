class ZencoderCallbackController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate
  layout false

  def create
    # zencoder_response = ''
    # sanitized_params = sanitize_params(params)
    # sanitized_params.each do |key, value|
    #   zencoder_response = key.gsub('\"', '"')
    # end

    # Rails.logger.info '-----------------------'
    # Rails.logger.info '-----------------------'
    # Rails.logger.info '-----------------------'
    # Rails.logger.info params.inspect
    # Rails.logger.info '-----------------------'
    # Rails.logger.info '-----------------------'
    # Rails.logger.info '-----------------------'

    # json = JSON.parse(zencoder_response)
    # Rails.logger.info json["output"]
    output_id = params["output"]["id"]
    job_state = params["output"]["state"]


Rails.logger.info '-----------------------'
Rails.logger.info '-----------------------'
Rails.logger.info '-----------------------'
    video = Video.find_by_zencoder_output_id(output_id.to_s)
    if job_state == "finished" && video
      video.width = params["output"]["width"]
      video.height = params["output"]["height"]
      video.filesize = params["output"]["filesize"]
      video.duration = params["output"]["duration"]
      video.processed!
      video.save
    end
Rails.logger.info '-----------------------'
Rails.logger.info '-----------------------'
Rails.logger.info '-----------------------'
    render :nothing => true
  end

  private

  def sanitize_params(params)
    params.delete(:action)
    params.delete(:controller)
    params
  end

end
