# frozen_string_literal: true

class Admin::AnswersController < Admin::BaseController
  before_action :find_answer

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to admin_person_path(@answer.person), notice: 'Answer was successfully updated.' }
      else
        format.html { redirect_to admin_person_path(@answer.person), warning: 'Problem saving answer.' }
      end
      format.js {}
    end
  end

  private

    def find_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      ap = params.require(:answer).permit(:value)
      ap[:value] = params[:checkboxes].join(', ') if params[:checkboxes]
      ap
    end
end
