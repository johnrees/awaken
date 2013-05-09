class ApplicationController < ActionController::Base
  protect_from_forgery
  layout proc {|controller| controller.request.xhr? ? false: "application" }
  # http_basic_authenticate_with name: ENV['HTTP_USER'], password: ENV['HTTP_PASSWORD']

  before_filter :authenticate if Rails.env.production?

  def authenticate

    authenticate_or_request_with_http_basic('Secret') do |username, password|
      username == ENV['HTTP_USER'] && password == ENV['HTTP_PASSWORD']
    end
  end
end
