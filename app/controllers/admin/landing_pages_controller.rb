# frozen_string_literal: true
class Admin::LandingPagesController < Admin::BaseController
  before_action :find_landing_page, only: [:edit, :update, :destroy]
  before_action :find_unused_tags, except: [:index, :destroy]

  def index
    @landing_pages = LandingPage.joins(:tag).order('tags.name ASC').page params[:page]
  end

  def new
    @landing_page = LandingPage.new
    @landing_page.build_tag
  end

  def create
    @landing_page = LandingPage.new(landing_page_params)
    if @landing_page.save
      redirect_to admin_landing_pages_path, notice: 'Landing page was created.'
    else
      flash.now[:error] = @landing_page.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @landing_page.update_attributes(landing_page_params)
      redirect_to admin_landing_pages_path, notice: 'Landing page was updated.'
    else
      flash.now[:error] = @landing_page.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @landing_page.destroy
      flash[:notice] = 'Landing page was deleted.'
    else
      flash[:error] = 'Problem deleting landing page.'
    end

    redirect_to admin_landing_pages_path
  end

  private

    def find_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    def find_unused_tags
      used_tags = LandingPage.joins(:tag).where.not(id: @landing_page).pluck(:name)
      @unused_tags = Tag.where.not(name: used_tags)
    end

    def landing_page_params
      params.require(:landing_page).permit(:format, :lede, :body, :image, :form_id, tag_attributes: [:name])
    end
end
