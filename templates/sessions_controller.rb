class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      render json: { user_email: user.email, user_token: user.api_keys.create.access_token }, status: 201
    else
      render json: { errors: ['Invalid Email or Password.'] }, status: :unauthorized
    end
  end

  def destroy
    # see https://github.com/rails/rails/blob/777142d3a7b9ea36fcc8562613749299ac6dc243/actionpack/lib/action_controller/metal/http_authentication.rb#L448
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    api_key = current_user.active_api_key(token)
    api_key.destroy
    render json: api_key, status: 201
  end
end
