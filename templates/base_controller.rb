class Api::BaseController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_reader :current_user

  before_action :authenticate_user_from_token!

  private

  # Renders a 401 status code if the current user is not authorized
  def authenticate_user_from_token!
    @current_user = nil

    authenticate_or_request_with_http_token do |token, options|
      user_email = options[:user_email].presence
      user       = user_email && User.find_by_email(user_email)

      if user && user.active_api_key(token).present?
        @current_user = user
      end
    end

    head :unauthorized unless @current_user
  end
end
