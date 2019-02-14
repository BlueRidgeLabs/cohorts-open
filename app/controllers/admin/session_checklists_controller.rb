# frozen_string_literal: true
class Admin::SessionChecklistsController < Admin::BaseController
  before_action :find_session_checklist

  def update
    if update_checklist_state(params[:session_checklist][:state]) && @session_checklist.save
      flash[:notice] = 'Checklist saved!'
    else
      flash[:error] = @session_checklist.errors.full_messages.to_sentence
    end
    redirect_to :back
  end

  private

    def find_session_checklist
      @session_checklist = SessionChecklist.find(params[:id])
    end

    def update_checklist_state(new_state)
      new_state.each do |k, v|
        @session_checklist.state[k] = v
      end
    end
end
