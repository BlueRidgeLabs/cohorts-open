# frozen_string_literal: true
class Admin::CommentsController < Admin::BaseController

  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show; end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit; end

  # POST /comments
  # POST /comments.json
  def create
    if contact_params[:contact_check] == '1'
      structure_contact_response(contact_params)
    else
      @comment = Comment.new(comment_params)
      respond_to do |format|
        if @comment.with_user(current_admin_user).save
          # format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
          format.js   {}
          # format.json { render action: 'show', status: :created, location: @comment }
        else
          # format.html { render action: 'new' }
          format.js   { render '/admin/comments/error.js.haml' }
          # format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.with_user(current_admin_user).update(comment_params)
        format.html { redirect_to admin_comment_path(@comment), notice: 'Comment was successfully updated.' }
        format.js   {}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js   {}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      # format.html { redirect_to admin_comments_url }
      # format.json { head :no_content }
      format.js {}
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :commentable_type, :commentable_id)
    end

    def contact_params
      params.require(:comment).permit(:content, :contact_check, :contact_type, :commentable_type, :commentable_id)
    end

    def structure_contact_response(contact_params)
      contactable_params = {
        contactable_type: contact_params[:commentable_type],
        contact_time: Time.zone.now.to_s(:short_ordinal),
        contact_type: contact_params[:contact_type],
        contactable_id: contact_params[:commentable_id],
        notes: contact_params[:content]
      }
      Person.find(contactable_params[:contactable_id]).update_column(:last_contacted, Time.zone.now)
      @contact = Contact.new(contactable_params)
      respond_to do |format|
        if @contact.with_user(current_admin_user).save
          format.js { render '/admin/contacts/create.js.haml' }
        else
          format.js  { render '/admin/contacts/error.js.haml' }
        end
      end
    end
end
