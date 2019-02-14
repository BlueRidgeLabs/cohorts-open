# frozen_string_literal: true
class StaticPageController < ApplicationController
  def show
    @static_page = StaticPage.friendly.find(params[:id])

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the page_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if request.path != static_page_path(@static_page)
      return redirect_to static_page_path(@static_page), status: :moved_permanently
    end
  end
end
