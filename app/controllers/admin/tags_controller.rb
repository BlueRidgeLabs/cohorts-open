# frozen_string_literal: true
class Admin::TagsController < Admin::BaseController
  before_action :find_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.order(taggings_count: :desc, name: :asc).page params[:page]
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path, notice: 'Tag was created.'
    else
      flash[:error] = @tag.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @tag.update_attributes(tag_params)
      redirect_to admin_tags_path, notice: 'Tag was updated.'
    else
      flash[:error] = @tag.errors.full_messages.to_sentence
      render :edit
    end
  end

  # def destroy
  #   if @tag.destroy
  #     flash[:notice] = 'Tag was deleted.'
  #   else
  #     flash[:error] = 'Problem deleting tag.'
  #   end

  #   redirect_to admin_tags_path
  # end

  private

    def find_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end
end
