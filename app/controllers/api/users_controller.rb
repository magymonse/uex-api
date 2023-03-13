class Api::UsersController < Api::BaseController
  before_action :set_user, only: [:create, :show, :update, :destroy]

  def show
    render json: @user
  end

  def set_user
    @user = if params[:id]
      User.find(params[:id])
    else
      User.new(user_params)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end