module ApplicationHelper

  def user_authorized_for(object)
    user_signed_in? && current_user.id == object.user_id
  end
end
