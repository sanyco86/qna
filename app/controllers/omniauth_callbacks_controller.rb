class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :provider_sign_in, only: [:facebook, :vkontakte, :finish_sign_up]

  def facebook
  end

  def vkontakte
  end

  def finish_sign_up
  end

  private

  def provider_sign_in
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:notice] = 'Email is required to compete sign up'
      render 'omniauth_callbacks/prompt_email', locals: { auth: auth }
    end
  end

  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end
