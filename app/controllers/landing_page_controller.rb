# frozen_string_literal: true
class LandingPageController < ApplicationController
  def index
    @tag_name = params[:tag_name]
    @landing_page = LandingPage.for_tag(@tag_name)
    render :simple if @landing_page&.simple_format?
  end
end
