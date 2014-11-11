class Api::UsersController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:create]

  def index
    render json: User.order(:email)
  end

  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: { user_id: user.id, user_token: user.api_keys.create.access_token }, status: :created
    else
      render json: { errors: user.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
