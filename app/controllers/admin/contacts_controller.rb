# frozen_string_literal: true
class Admin::ContactsController < Admin::BaseController

  before_action :set_contact, only: [:edit, :update, :destroy]

  def index
    @contacts = Contact.all
  end

  def update
    respond_to do |format|
      if @contact.with_user(current_admin_user).update(contact_params)
        format.html { redirect_to admin_contact_path(@contact), notice: 'Contact was successfully updated.' }
        format.js   {}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js   {}
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.with_user(current_admin_user).save
        # format.html { redirect_to @contact, notice: 'contact was successfully created.' }
        format.js   {}
        # format.json { render action: 'show', status: :created, location: @contact }
      else
        # format.html { render action: 'new' }
        format.js   { escape_javascript("console.log('error saving contact: #{@contact.errors.inspect}');") }
        # format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:contact_type, :user_id, :contactable_type, :contactable_id, :notes, :contact_time)
    end
end
