# frozen_string_literal: true
class Admin::StaticPagesController < Admin::BaseController
  before_action :find_static_page, only: [:edit, :update, :destroy]

  def index
    @static_pages = StaticPage.all.page params[:page]
  end

  def new
    @static_page = StaticPage.new
  end

  def create
    @static_page = StaticPage.new(static_page_params)
    if @static_page.save
      redirect_to admin_static_pages_path, notice: 'Static page was created.'
    else
      flash.now[:error] = @static_page.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @static_page.update_attributes(static_page_params)
      redirect_to admin_static_pages_path, notice: 'Static page was updated.'
    else
      flash.now[:error] = @static_page.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @static_page.destroy
      flash[:notice] = 'Static page was deleted.'
    else
      flash[:error] = 'Problem deleting static page.'
    end

    redirect_to admin_static_pages_path
  end

  private

    def find_static_page
      @static_page = StaticPage.friendly.find(params[:id])
    end

    def static_page_params
      params.require(:static_page).permit(:title, :body, :pixel_code, :link_description)
    end
end
