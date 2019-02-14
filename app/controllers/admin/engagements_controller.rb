# frozen_string_literal: true
class Admin::EngagementsController < Admin::BaseController
  before_action :find_client
  before_action :find_engagement, only: [:show, :edit, :update, :destroy]
  before_action :parse_dates, only: [:create, :update]

  def index
    @engagements = Engagement.order('end_date DESC').page params[:page]
  end

  def show
    @eligible_members = @engagement.eligible_members(filter: params[:filter])
  end

  def new
    @engagement = Engagement.new(
      client: @client,
      checklist_ids: @client&.checklist_ids
    )
  end

  def create
    @engagement = Engagement.new(engagement_params)
    if @engagement.save
      redirect_to admin_engagement_path(@engagement), notice: 'Engagement was created.'
    else
      flash[:error] = @engagement.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @engagement.update_attributes(engagement_params)
      redirect_to admin_engagement_path(@engagement), notice: 'Engagement was updated.'
    else
      flash[:error] = @engagement.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @engagement.destroy
      flash[:notice] = 'Engagement was deleted.'
    else
      flash[:error] = 'Problem deleting engagment.'
    end

    redirect_to admin_engagements_path
  end

  private

    def find_client
      @client = Client.find(params[:client_id]) if params[:client_id]
    end

    def find_engagement
      @engagement = Engagement.find(params[:id])
    end

    def parse_dates
      params[:start_date] = Date.parse(params[:start_date]) if params[:start_date]
      params[:end_date] = Date.parse(params[:end_date]) if params[:end_date]
    end

    def engagement_params
      params.require(:engagement).permit(:client_id, :topic, :start_date, :end_date, :notes, saved_search_ids: [], checklist_ids: [])
    end
end
