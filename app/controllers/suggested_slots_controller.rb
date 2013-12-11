class SuggestedSlotsController < ApplicationController
    before_filter :get_studio
    
    def get_studio
        @studio = Studio.find(params[:studio_id])
    end
    
  # GET /suggested_slots
  # GET /suggested_slots.json
  def index
    @suggested_slots = SuggestedSlot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @suggested_slots }
    end
  end

  # GET /suggested_slots/1
  # GET /suggested_slots/1.json
  def show
    @suggested_slot = SuggestedSlot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @suggested_slot }
    end
  end

  # GET /suggested_slots/new
  # GET /suggested_slots/new.json
  def new
    @suggested_slot = @studio.suggested_slots.new
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @suggested_slot }
    end
  end

  # GET /suggested_slots/1/edit
  def edit
    @suggested_slot = SuggestedSlot.find(params[:id])
  end

  # POST /suggested_slots
  # POST /suggested_slots.json
  def create
    @suggested_slot = @studio.suggested_slots.new(params[:suggested_slot])

    respond_to do |format|
      if @suggested_slot.save
        format.html { redirect_to edit_studio_path(@studio), :notice => 'Suggested slot was successfully created.' }
        format.json { render :json => @suggested_slot, :event => :created, :location => @suggested_slot }
      else
        format.html { render :action => "new" }
        format.json { render :json => @suggested_slot.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /suggested_slots/1
  # PUT /suggested_slots/1.json
  def update
    @suggested_slot = SuggestedSlot.find(params[:id])

    respond_to do |format|
      if @suggested_slot.update_attributes(params[:suggested_slot])
        format.html { redirect_to @suggested_slot, :notice => 'Suggested slot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @suggested_slot.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /suggested_slots/1
  # DELETE /suggested_slots/1.json
  def destroy
    @suggested_slot = SuggestedSlot.find(params[:id])
    @suggested_slot.destroy

    respond_to do |format|
      format.html { redirect_to suggested_slots_url }
      format.json { head :no_content }
    end
  end
end
