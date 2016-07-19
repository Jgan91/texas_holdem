class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    else
      redirect_to root_path
    end
  end

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
