# frozen_string_literal: true
class Admin::TraitsController < Admin::BaseController
  before_action :find_person
  before_action :find_trait, only: [:edit, :update, :destroy]

  def index
    @traits = Trait.order(person_traits_count: :desc, name: :asc).page params[:page]
  end

  def create
    # TODO: Maybe we need to create a different controller to assign PersonTraits.
    if params[:person_trait]
      create_person_trait
    else
      create_trait
    end
  end

  def update
    if params[:person_trait]
      update_person_trait
    else
      update_trait
    end
  end

  def destroy
    @person_trait.destroy
    respond_to do |format|
      format.js {}
    end
  end

  private

    def find_person
      @person = Person.find(params[:person_id]) if params[:person_id]
    end

    def find_trait
      @trait = Trait.find(params[:id])
      @person_trait = PersonTrait.find_by(person: @person, trait: @trait)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trait_params
      params.require(:trait).permit(:name)
    end

    def person_trait_params
      params.require(:person_trait).permit(:value)
    end

    def create_trait
      @trait = Trait.new(trait_params)
      if @trait.save
        redirect_to admin_traits_path, notice: 'Trait was created.'
      else
        flash[:error] = @trait.errors.full_messages.to_sentence
        render :new
      end
    end

    def create_person_trait
      @trait = Trait.find_or_create_by(name: trait_params[:name])
      @person_trait = PersonTrait.new(trait: @trait, person: @person, value: person_trait_params[:value])

      respond_to do |format|
        if @person_trait.save
          format.js {}
        else
          format.js { escape_javascript("console.log('error saving trait: #{@person_trait.errors.inpsect}');") }
        end
      end
    end

    def update_trait
      if @trait.update_attributes(trait_params)
        redirect_to admin_traits_path, notice: 'Trait was updated.'
      else
        flash[:error] = @trait.errors.full_messages.to_sentence
        render :edit
      end
    end

    def update_person_trait
      respond_to do |format|
        if @person_trait.update(person_trait_params)
          format.js {}
        else
          format.js { escape_javascript("console.log('error saving trait: #{@person_trait.errors.inpsect}');") }
        end
      end
    end
end
