# frozen_string_literal: true
class Admin::ChecklistsController < Admin::BaseController
  before_action :find_checklist, only: [:show, :edit, :update, :destroy]

  def index
    @checklists = Checklist.order(name: :asc).page params[:page]
  end

  def create
    @checklist = Checklist.new(checklist_params)
    if @checklist.save
      redirect_to admin_checklists_path, notice: 'Checklist was created.'
    else
      flash[:error] = @checklist.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @checklist.update_attributes(checklist_params)
      redirect_to admin_checklists_path, notice: 'Checklist was updated.'
    else
      flash[:error] = @checklist.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @checklist.destroy
      flash[:notice] = 'Checklist was deleted.'
    else
      flash[:error] = 'Problem deleting checklist.'
    end

    redirect_to admin_checklists_path
  end

  private

    def find_checklist
      @checklist = Checklist.find(params[:id])
    end

    def checklist_params
      checklist = params.require(:checklist).permit(:name, :items, engagement_ids: [])
      checklist[:items] = checklist[:items].split(', ')
      checklist
    end
end
