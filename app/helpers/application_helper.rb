module ApplicationHelper

  def user_authorized_for(object)
    user_signed_in? && current_user == object.user
  end
end
