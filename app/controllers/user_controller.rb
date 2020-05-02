class UserController < ApplicationController
  def edit
    if current_user.id.to_s == params[:id]
      @user = current_user
    else
      redirect_to root_path, alert: 'Forbidden request'
    end
  end

  def update
    @user = current_user
    if @user.update(user_update_params)
      redirect_to root_path, notice: 'Your profile updated'
    else
      redirect_to edit_user_path, alert: 'Your profile not updated'
    end
  end

  private

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
