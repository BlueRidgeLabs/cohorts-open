# frozen_string_literal: true
class Admin::QuestionsController < Admin::BaseController
  before_action :find_question, except: [:index]

  def index
    @questions = Question.order(answers_count: :desc).page params[:page]
  end

  def show
    @answers = @question.answers.order(created_at: :desc)
    if %w(radio select checkbox).include? @question.datatype
      @choices = Kaminari.paginate_array(@question.choices).page(params[:page])
    else
      @answers = @answers.page(params[:page])
    end
    respond_to do |format|
      format.html {}
      format.json {}
    end
  end

  def choices
    respond_to do |format|
      format.json {}
    end
  end

  private

    def find_question
      @question = Question.find(params[:id])
    end
end
