class Api::UsersController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: { user_email: user.email, user_token: user.api_keys.create.access_token }, status: 201
    else
      render json: { errors: user.errors.messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
