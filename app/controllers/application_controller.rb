class ApplicationController < ActionController::Base
  protect_from_forgery
  layout proc {|controller| controller.request.xhr? ? false: "application" }
  if Rails.env.production?
    http_basic_authenticate_with name: ENV['HTTP_USER'],
      password: ENV['HTTP_PASSWORD']
  end
end
