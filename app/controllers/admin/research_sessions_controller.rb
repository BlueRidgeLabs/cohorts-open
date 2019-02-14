# frozen_string_literal: true
class Admin::ResearchSessionsController < Admin::BaseController
  before_action :find_engagement
  before_action :find_research_session, only: [:show, :edit, :update, :destroy]

  def index
    @research_sessions = ResearchSession.order(:datetime)
  end

  def new
    @research_session = ResearchSession.new(engagement: @engagement)
  end

  def create
    @research_session = ResearchSession.new(research_session_params)
    if @research_session.save
      redirect_to admin_engagement_research_session_path(@engagement, @research_session), notice: 'Session was created.'
    else
      flash[:error] = @research_session.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @research_session.update_attributes(research_session_params)
      redirect_to admin_engagement_research_session_path(@engagement, @research_session), notice: 'Session was updated.'
    else
      flash[:error] = @research_session.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @research_session.destroy
      flash[:notice] = 'Session was deleted.'
    else
      flash[:error] = 'Problem deleting session.'
    end

    redirect_to admin_engagement_path(@engagement)
  end

  private

    def find_engagement
      @engagement = Engagement.find(params[:engagement_id])
    end

    def find_research_session
      @research_session = @engagement.research_sessions.find(params[:id])
    end

    def research_session_params
      rsp = params.require(:research_session).permit(:engagement_id, :date, :time, :notes, person_ids: [])
      rsp[:datetime] = Time.zone.parse([rsp.delete(:date), rsp.delete(:time)].join(' '))
      rsp
    end
end
