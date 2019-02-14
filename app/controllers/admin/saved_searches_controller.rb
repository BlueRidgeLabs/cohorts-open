# frozen_string_literal: true
class Admin::SavedSearchesController < Admin::BaseController
  before_action :find_saved_search, only: [:edit, :update, :destroy]

  def index
    @saved_searches = SavedSearch.order(created_at: :desc).page params[:page]
  end

  def create
    @saved_search = SavedSearch.new(saved_search_params)
    if @saved_search.save
      flash[:notice] = "Search saved as '#{@saved_search.label}'."
    else
      flash[:error] = @saved_search.errors.full_messages.to_sentence
    end
    redirect_to :back
  end

  def update
    if @saved_search.update_attributes(saved_search_params)
      redirect_to admin_saved_searches_path, notice: 'Saved search was updated.'
    else
      flash[:error] = @saved_search.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @saved_search.destroy
      flash[:notice] = 'Saved search was deleted.'
    else
      flash[:error] = 'Problem deleting saved search.'
    end
    redirect_to admin_saved_searches_path
  end

  private

    def find_saved_search
      @saved_search = SavedSearch.find(params[:id])
    end

    def saved_search_params
      params.require(:saved_search).permit(:label, :query)
    end
end
