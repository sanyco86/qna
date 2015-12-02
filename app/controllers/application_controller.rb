require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  after_action :verify_authorized, except: :index

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: 'Not authorized'} }
  end

  private

  def user_not_authorized
    respond_to do |format|
      format.html {
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_to(request.referrer || root_path)
      }
      format.json {
        self.response_body = nil
        render json: {error: 'You are not authorized to perform this action.'}
      }
    end
  end
end
