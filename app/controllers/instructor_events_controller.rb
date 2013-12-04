class InstructorEventsController < ApplicationController
  def new
    @booking = Booking.find(params["booking_id"])
    @instructor_event = InstructorEvent.new(:booking => @booking)
		
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer 
		
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @instructor_event }
    end
	end
		
	def create
    @instructor_event = InstructorEvent.new(params[:instructor_event])
				
		#We need to instantiate the @booking variable in case there's a save error, because the "new" view uses it
		@booking = @instructor_event.booking

    respond_to do |format|
      if @instructor_event.save
        format.html { redirect_to session.delete(:return_to), :notice => 'Instructor note was successfully created.' }
        format.json { render :json => @instructor_event, :event => :created, :location => @instructor_event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @instructor_event.errors, :event => :unprocessable_entity }
      end
    end
  end

  def edit
		# record where the user came from so we can return them there after the save
		session[:return_to] ||= request.referer
		
    @instructor_event = InstructorEvent.find(params[:id])
    @booking = @instructor_event.booking
  end
	
  def update
    @instructor_event = InstructorEvent.find(params[:id])
		@booking = @instructor_event.booking

    respond_to do |format|
      if @instructor_event.update_attributes(params[:instructor_event])
        format.html { redirect_to session.delete(:return_to), :notice => 'Instructor note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @instructor_event.errors, :event => :unprocessable_entity }
      end
    end
	end
	
	def destroy
		session[:return_to] ||= request.referer # record where the user came from so we can return them there after the save
    @instructor_event = InstructorEvent.find(params[:id])
    @instructor_event.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), :notice => 'Instructor note was deleted.' }
      format.json { head :no_content }
    end
  end
end
