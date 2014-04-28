class AvailabilitySlotsController < ApplicationController
  before_filter :get_studio
    
  def get_studio
    @studio = Studio.find(params[:studio_id])
  end

  def new
    @availability_slot = @studio.availability_slots.new
    session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @availability_slot }
    end
  end

  # GET /availability_slots/1/edit
  def edit
    @availability_slot = availabilitySlot.find(params[:id])
  end

  # POST /availability_slots
  # POST /availability_slots.json
  def create
    @availability_slot = @studio.availability_slots.new(params[:availability_slot])

    respond_to do |format|
      if @availability_slot.save
        format.html { redirect_to edit_studio_path(@studio), :notice => 'Availability slot was successfully created.' }
        format.json { render :json => @availability_slot, :event => :created, :location => @availability_slot }
      else
        format.html { render :action => "new" }
        format.json { render :json => @availability_slot.errors, :event => :unprocessable_entity }
      end
    end
  end

  # PUT /availability_slots/1
  # PUT /availability_slots/1.json
  def update
    @availability_slot = AvailabilitySlot.find(params[:id])

    respond_to do |format|
      if @availability_slot.update_attributes(params[:availability_slot])
        format.html { redirect_to @availability_slot, :notice => 'Availability slot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @availability_slot.errors, :event => :unprocessable_entity }
      end
    end
  end

  # DELETE /availability_slots/1
  # DELETE /availability_slots/1.json
  def destroy
    @availability_slot = AvailabilitySlot.find(params[:id])
    @availability_slot.destroy

    respond_to do |format|
      format.html { redirect_to availability_slots_url }
      format.json { head :no_content }
    end
  end
end
