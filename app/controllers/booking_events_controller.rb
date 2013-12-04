class BookingEventsController < ApplicationController
  def new
    @booking = Booking.find(params["booking_id"])
    @booking_event = BookingEvent.new(:booking => @booking)
		
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer 
		
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @booking_event }
    end
	end
	
  def edit
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer
		
    @booking_event = BookingEvent.find(params[:id])
    @booking = @booking_event.booking
  end
		
	def create
    @booking_event = BookingEvent.new(params[:booking_event])
				
		#We need to instantiate the @booking variable in case there's a save error, because the "new" view uses it
		@booking = @booking_event.booking

    respond_to do |format|
      if @booking_event.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Booking note was successfully created.' }
        format.json { render :json => @booking_event, :event => :created, :location => @booking_event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @booking_event.errors, :event => :unprocessable_entity }
      end
    end
  end
	
  def update
    @booking_event = BookingEvent.find(params[:id])
		@booking = @booking_event.booking

    respond_to do |format|
      if @booking_event.update_attributes(params[:booking_event])
        format.html { redirect_to session.delete(:return_to), :notice => 'Booking Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @booking_event.errors, :event => :unprocessable_entity }
      end
    end
	end
	
	def destroy
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    @booking_event = BookingEvent.find(params[:id])
    @booking_event.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), :notice => 'Booking event was deleted.' }
      format.json { head :no_content }
    end
  end
end
