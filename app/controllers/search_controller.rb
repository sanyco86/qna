class SearchController < ApplicationController
  skip_after_action :verify_authorized

  def search
    if params[:query].present?
      @results = Search.filter(params[:query], condition: params[:condition])
    else
      @results = []
    end
    respond_with @results
  end
end

