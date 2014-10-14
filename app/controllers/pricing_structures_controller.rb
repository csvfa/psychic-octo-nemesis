class PricingStructuresController < ApplicationController
  # GET /pricing_structures
  # GET /pricing_structures.json
  def index
    @pricing_structures = PricingStructure.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pricing_structures }
    end
  end

  # GET /pricing_structures/1
  # GET /pricing_structures/1.json
  def show
    @pricing_structure = PricingStructure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pricing_structure }
    end
  end

  # GET /pricing_structures/new
  # GET /pricing_structures/new.json
  def new
    @pricing_structure = PricingStructure.new
    session[:return_to] = request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pricing_structure }
    end
  end

  # GET /pricing_structures/1/edit
  def edit
    @pricing_structure = PricingStructure.find(params[:id])
  end

  # POST /pricing_structures
  # POST /pricing_structures.json
  def create
    @pricing_structure = PricingStructure.new(params[:pricing_structure])

    respond_to do |format|
      if @pricing_structure.save
        format.html { redirect_to session.delete(:return_to), notice: 'Pricing structure was successfully created.' }
        format.json { render json: @pricing_structure, status: :created, location: @pricing_structure }
      else
        format.html { render action: "new" }
        format.json { render json: @pricing_structure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pricing_structures/1
  # PUT /pricing_structures/1.json
  def update
    @pricing_structure = PricingStructure.find(params[:id])

    respond_to do |format|
      if @pricing_structure.update_attributes(params[:pricing_structure])
        format.html { redirect_to pricing_structures_path, notice: 'Pricing structure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pricing_structure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pricing_structures/1
  # DELETE /pricing_structures/1.json
  def destroy
    @pricing_structure = PricingStructure.find(params[:id])
    @pricing_structure.destroy

    respond_to do |format|
      format.html { redirect_to pricing_structures_url }
      format.json { head :no_content }
    end
  end
end
