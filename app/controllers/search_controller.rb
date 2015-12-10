class SearchController < ApplicationController
  skip_after_action :verify_authorized

  def search
    @questions = Question.search load_conditions
    respond_with @questions
  end

  private

  def load_conditions
    case conditions
      when 'everywhere'
        query
      when 'questions'
        { conditions: { title: query, body: query } }
      else
        { conditions: { conditions => query } }
    end
  end

  def query
    Riddle::Query.escape(params[:search][:query])
  end

  def conditions
    params[:search][:conditions]
  end
end
