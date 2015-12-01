class Api::V1::ProfilesController < Api::V1::BaseController
  skip_after_action :verify_authorized

  def index
    respond_with User.where.not(id: current_resource_owner)
  end

  def me
    respond_with current_resource_owner
  end
end
