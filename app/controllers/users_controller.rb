class UsersController < ApplicationController
  def finish_signup
    @user = User.find(params[:id])
    if request.patch? && params[:user]
      if @user.update(user_params)
        sign_in(@user, :bypass => true)
        redirect_to root_url, notice: 'Your email was updated. We have sent you a confirmation email.'
      else
        render :finish_signup
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end