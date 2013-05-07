class ZencoderCallbackController < ActionController::Base

  skip_before_filter :verify_authenticity_token
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
    video = Video.find_by_zencoder_output_id(output_id)
    if job_state == "finished" && video
      video.processed!
      # video.save
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
