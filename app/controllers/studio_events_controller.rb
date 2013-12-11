class StudioEventsController < EventsController
  def new
    @booking = Booking.find(params["booking_id"])
		
		#Make the new event
    @studio_event = StudioEvent.new(:booking => @booking) 	
			
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer 
		
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @studio_event }
    end
	end
		
	def create
    @studio_event = StudioEvent.new(params[:studio_event])
		
		#We need to instantiate the @booking variable in case there's a save error, because the "new" view uses it
		@booking = @studio_event.booking
        
        return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s

    respond_to do |format|
      if @studio_event.save
        format.html { redirect_to return_path, :notice => 'Studio note was successfully created.' }
        format.json { render :json => @studio_event, :event => :created, :location => @studio_event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @studio_event.errors, :event => :unprocessable_entity }
      end
    end
  end

  def edit
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer
		
    @studio_event = StudioEvent.find(params[:id])
    @booking = @studio_event.booking
  end
	
  def update
    @studio_event = StudioEvent.find(params[:id])
		@booking = @studio_event.booking
      
      return_path = session.delete(:return_to) + "#booking" + @booking.id.to_s

    respond_to do |format|
      if @studio_event.update_attributes(params[:studio_event])
        format.html { redirect_to return_path, :notice => 'Studio note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @studio_event.errors, :event => :unprocessable_entity }
      end
    end
	end
	
	def destroy
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    @studio_event = StudioEvent.find(params[:id])
        
        return_path = session.delete(:return_to) + "#booking" + @studio_event.booking.id.to_s
        
    @studio_event.destroy

    respond_to do |format|
      format.html { redirect_to return_path, :notice => 'Studio note was deleted.' }
      format.json { head :no_content }
    end
  end
end