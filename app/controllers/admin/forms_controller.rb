# frozen_string_literal: true
class Admin::FormsController < Admin::BaseController
  before_action :find_form, only: [:edit, :update]

  # GET /forms
  # GET /forms.json
  def index
    @forms = Form.where(hidden: false).page params[:page]
  end

  def hidden
    @forms = Form.where(hidden: true).page params[:page]
  end

  def update_from_wufoo
    Form.update_forms
    flash[:notice] = 'Forms updated successfully.'
    redirect_to action: :index
  end

  def edit; end

  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html do
          flash[:notice] = "\"#{@form.name}\" updated."
          redirect_to action: :index
        end
        format.json { head :no_content }
      else
        format.html { redirect_to action: :index }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def find_form
      @form = Form.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.require(:form).permit(:twilio_keyword, :hidden)
    end
end
