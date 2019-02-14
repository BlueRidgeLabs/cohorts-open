# frozen_string_literal: true
class Admin::SubmissionsController < Admin::BaseController
  skip_before_action :authenticate_admin_user!, if: :should_skip_janky_auth?
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :find_submission, only: [:show, :edit, :update]
  before_action :check_correct_handshake, only: [:create]

  # GET /submissions
  def index
    @submissions_unmatched = Submission.order('created_at DESC').where('person_id is ?', nil)
    @submissions = Submission.order('created_at DESC').includes(:person).page params[:page]
  end

  # GET /submission/:id
  def show; end

  # GET /submission/new
  def new
    @submission = Submission.new
  end

  def create
    if params['HandshakeKey'].present?
      HandleWufooSubmissionJob.perform_now(params)
      head :ok
    else
      @submission = Submission.new(
        entry_id: submission_params['entry_id'], person_id: submission_params['person_id'],
        form_id: submission_params['form_id']
      )
      @submission.find_wufoo_entry
      if @submission.save
        Rails.logger.info("[SubmissionsController#create] Recorded a new manual submission for #{@submission.person&.full_name}")
        flash[:notice] = 'Submission created successfully.'
        redirect_to action: :index
      else
        Rails.logger.warn("[SubmissionsController#create] Failed to save new manual submission for #{@submission.person&.full_name}")
      end
    end
  end

  # GET /submission/1/edit
  def edit; end

  # PATCH/PUT /submission/1
  # PATCH/PUT /submission/1.json
  def update
    respond_to do |format|
      if @submission.with_user(current_admin_user).update(submission_params)
        format.html { redirect_to admin_submissions_path, notice: 'Submission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def find_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:raw_content, :person_id, :ip_addr, :entry_id, :form_structure, :field_structure, :form_id, :form_type)
    end

    def should_skip_janky_auth?
      # don't attempt authentication on reqs from wufoo
      params[:action] == 'create' && params['HandshakeKey'].present?
    end

    def check_correct_handshake
      if params['HandshakeKey'].present? && !params['HandshakeKey'].start_with?(Cohorts::Application.config.wufoo_handshake_key_prefix)
        Rails.logger.warn("[SubmissionsController#create] Received request with invalid handshake. Full request: #{request.inspect}")
        head(403) && return
      end
    end

end
