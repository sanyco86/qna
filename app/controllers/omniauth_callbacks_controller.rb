class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :provide_callback, only: [:twitter, :facebook]

  def twitter
  end

  def facebook
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  private

  def provide_callback
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: "#{action_name}".capitalize) if is_navigational_format?
    end
  end
end