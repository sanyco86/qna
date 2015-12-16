class SearchController < ApplicationController
  skip_after_action :verify_authorized

  def search
    params[:query].present? ? @results = Search.filter(params[:query], condition: params[:condition]) : @results = []
    respond_with @results
  end
end
