# frozen_string_literal: true

class Admin::ClientsController < Admin::BaseController
  before_action :find_client, only: %i(show edit update destroy)

  def index
    @clients = Client.order(:name).page params[:page]
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to admin_client_path(@client), notice: 'Client was created.'
    else
      flash[:error] = @client.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @client.update_attributes(client_params)
      redirect_to admin_client_path(@client), notice: 'Client was updated.'
    else
      flash[:error] = @client.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @client.destroy
      flash[:notice] = 'Client was deleted.'
    else
      flash[:error] = 'Problem deleting client.'
    end

    redirect_to admin_clients_path
  end

  private

    def find_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name, saved_search_ids: [], checklist_ids: [])
    end
end
