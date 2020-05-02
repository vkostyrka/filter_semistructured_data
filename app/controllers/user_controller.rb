class UserController < ApplicationController
  def edit
    if current_user.id.to_s == params[:id]
      @user = current_user
    else
      redirect_to root_path, alert: 'Forbidden request'
    end
  end

  def update
    binding.pry
  end

  private

  def user_update_params
    params.require(:dataset).permit(:first_name, :last_name, :email)
  end
end
